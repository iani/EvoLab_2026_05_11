Kickdrum : Creature {

	// =====================================================
	// EDITABLE SETTINGS (change these easily)
	// =====================================================

	var <autoEventsOn = true;     // AUTO EVENT TRIGGER: on/off (default)

	// How often auto-events happen (seconds), per EvoLab state:
	var <autoIntervalDawn   = #[3.5, 7.0];
	var <autoIntervalDay    = #[2.5, 6.0];
	var <autoIntervalDusk   = #[4.0, 9.0];
	var <autoIntervalNight  = #[7.0, 14.0];
	var <autoIntervalDanger = #[1.0, 3.0];

	// Overall loudness scaling for encounter overlays:
	var <breathAmpScale = 1.0;
	var <overlayKickAmpScale = 1.0;

	// =====================================================
	// INTERNAL STATE (don’t edit unless you want to)
	// =====================================================

	var <energy = 0.5;              // 0..1, affects density
	var <mood = \neutral;           // label for the last encounter
	var <currentState = \day;       // \dawn \day \dusk \night \danger
	var autoTask;                   // stores the running auto-event task (so we don't duplicate)


	// =====================================================
	// FILE LOADING
	// =====================================================
	*fileName { ^"kickdrum.wav" }


	// =====================================================
	// SYNTH DEFS (loaded once)
	// =====================================================
	*initClass {

		// ----- BODY: kick sample player -----
		SynthDef(\kickdrumPlayer, { |out=0, buf=0, amp=0.2, rate=1, pan=0, rel=0.25, hp=20|
			var sig, env;
			env = EnvGen.kr(Env.perc(0.001, rel), doneAction: 2);
			sig = PlayBuf.ar(1, buf, BufRateScale.kr(buf) * rate, doneAction: 2);
			sig = HPF.ar(sig, hp);
			Out.ar(out, Pan2.ar(sig * env * amp, pan));
		}).add;

		// ----- SOUL: breathy organic noise -----
		SynthDef(\kickdrumBreath, { |out=0, amp=0.03, soulFreq=200, pan=0,
			lagTime=0.2, atk=0.05, dec=0.2, sus=0.6, rel=0.8|

			var sig, env, f;
			f = Lag.kr(soulFreq.clip(40, 6000), lagTime.max(0.001));
			env = EnvGen.kr(Env.adsr(atk.max(0.001), dec.max(0.001), sus.clip(0, 1), rel.max(0.001)),
				gate: 1, doneAction: 2
			);

			sig = PinkNoise.ar;
			sig = BPF.ar(sig, f, 0.25) + (HPF.ar(sig, f * 0.8) * 0.15);
			sig = sig * (0.6 + LFNoise1.kr(0.7).range(0, 0.4));

			Out.ar(out, Pan2.ar(sig * env * amp, pan));
		}).add;
	}


	// =====================================================
	// UTILITIES
	// =====================================================
	getBuf {
		^( if(this.respondsTo(\buf)) { this.buf }
		   { if(this.respondsTo(\buffer)) { this.buffer } { nil } } );
	}

	playKick { |buf, rateMul=1.0, ampMul=1.0, hp=80|
		Synth(\kickdrumPlayer, [
			\out, 0,
			\buf, buf,
			\amp, (rrand(0.10, 0.28) * ampMul * overlayKickAmpScale),
			\rate, rateMul * [0.9, 1.0, 1.1, 1.2].choose,
			\pan, rrand(-0.6, 0.6),
			\rel, rrand(0.06, 0.20),
			\hp, hp
		]);
	}


	// =====================================================
	// REQUIRED EVOLAB STATES (these WILL be called by EvoLab)
	// =====================================================

	dawn {
		currentState = \dawn;
		energy = (energy + 0.05).clip(0, 1);

		// keep the main rhythm similar to day but slightly gentler
		this.day;

		if(autoEventsOn) { this.autoOn };
	}

	day {
		var buf = this.getBuf;
		if(buf.isNil) { "Kickdrum: buffer not ready yet.".warn; ^nil };

		currentState = \day;
		energy = (energy + 0.20).clip(0, 1);

		this.substitute(
			Task({
				var step;
				loop {
					step = [0.125, 0.25, 0.25, 0.375, 0.5].wchoose(
						[energy, 0.9, 1.0, 0.6, 0.25].normalizeSum
					);

					this.playKick(buf, 1.0, 0.9 + (energy * 0.6), 90);
					step.wait;
				}
			}).play,
			0.15
		);

		if(autoEventsOn) { this.autoOn };
	}

	dusk {
		currentState = \dusk;
		energy = (energy - 0.10).clip(0, 1);

		// keep the main rhythm similar to night but not as sparse
		this.night;

		if(autoEventsOn) { this.autoOn };
	}

	night {
		var buf = this.getBuf;
		if(buf.isNil) { "Kickdrum: buffer not ready yet.".warn; ^nil };

		currentState = \night;
		energy = (energy - 0.20).clip(0, 1);

		this.substitute(
			Task({
				loop {
					this.playKick(buf, 0.9, 0.55 + (energy * 0.4), 45);
					rrand(0.9, 2.6).wait;
				}
			}).play,
			0.5
		);

		if(autoEventsOn) { this.autoOn };
	}

	danger {
		var buf = this.getBuf;
		if(buf.isNil) { "Kickdrum: buffer not ready yet.".warn; ^nil };

		currentState = \danger;
		energy = 1.0;
		mood = \alarm;

		// intense, tight rhythm (feel free to tweak!)
		this.substitute(
			Task({
				loop {
					this.playKick(buf, 1.25, 1.25, 180);
					[0.08, 0.10, 0.12, 0.16].choose.wait;
				}
			}).play,
			0.08
		);

		if(autoEventsOn) { this.autoOn };
	}


	// =====================================================
	// ENCOUNTER ENGINE (your personal events)
	// =====================================================

	encounter { |eventType=\people, eventDetail=\neutral|
		var baseFreq = 180;

		// Breath parameters:
		var soulFreq = baseFreq;
		var atk = 0.05, dec = 0.2, sus = 0.6, rel = 0.8;
		var lagTime = 0.2;
		var breathAmp = 0.02 * breathAmpScale;
		var pan = rrand(-0.7, 0.7);

		// Kick coloring:
		var kickRateMul = 1.0;
		var kickAmpMul  = 1.0;
		var kickHP      = 80;

		// Overlay duration:
		var overlayDur  = 2.4;

		switch(eventType,

			\people, {
				switch(eventDetail,
					\stranger, {
						mood = \nervous;
						soulFreq = baseFreq + 320;
						atk=0.01; dec=0.10; sus=0.7; rel=0.35;
						lagTime = 0.06; breathAmp = 0.028 * breathAmpScale;
						kickRateMul = 1.10; kickHP = 140; overlayDur = 2.0;
					},
					\friend, {
						mood = \happy;
						soulFreq = baseFreq + 170;
						atk=0.05; dec=0.30; sus=0.5; rel=1.10;
						lagTime = 0.18; breathAmp = 0.024 * breathAmpScale;
						kickAmpMul = 1.10; kickHP = 90; overlayDur = 2.8;
					},
					\crowd, {
						mood = \overstimulated;
						soulFreq = baseFreq + 420;
						atk=0.005; dec=0.12; sus=0.65; rel=0.50;
						lagTime = 0.04; breathAmp = 0.032 * breathAmpScale;
						kickRateMul = 1.25; kickHP = 180; overlayDur = 2.6;
					}
				);
			},

			\walking, {
				switch(eventDetail,
					\cityStreet, {
						mood = \alert;
						soulFreq = baseFreq + 220;
						lagTime = 0.10; breathAmp = 0.026 * breathAmpScale;
						kickRateMul = 1.30; kickHP = 160; overlayDur = 3.0;
					},
					\forest, {
						mood = \calm;
						soulFreq = baseFreq - 55;
						lagTime = 0.55; breathAmp = 0.020 * breathAmpScale;
						kickRateMul = 0.90; kickHP = 50; overlayDur = 3.4;
					},
					\lake, {
						mood = \float;
						soulFreq = baseFreq - 25;
						lagTime = 0.65; breathAmp = 0.020 * breathAmpScale;
						kickRateMul = 0.82; kickHP = 45; overlayDur = 3.6;
					},
					\sea, {
						mood = \wide;
						soulFreq = baseFreq - 15;
						lagTime = 0.75; breathAmp = 0.022 * breathAmpScale;
						kickRateMul = 0.86; kickHP = 35; overlayDur = 4.2;
					}
				);
			},

			\eating, {
				switch(eventDetail,
					\comfort, {
						mood = \satisfied;
						soulFreq = baseFreq + 60;
						sus = 0.75; lagTime = 0.22;
						breathAmp = 0.023 * breathAmpScale;
						kickAmpMul = 0.95; overlayDur = 2.6;
					},
					\bitter, {
						mood = \disgust;
						soulFreq = baseFreq + 420;
						atk=0.01; dec=0.20; sus=0.25; rel=0.55;
						lagTime = 0.10; breathAmp = 0.030 * breathAmpScale;
						kickRateMul = 1.15; kickHP = 220; overlayDur = 2.2;
					}
				);
			},

			\movie, {
				switch(eventDetail,
					\scary, {
						mood = \fear;
						soulFreq = baseFreq + 360;
						atk=0.01; dec=0.20; sus=0.6; rel=0.75;
						lagTime = 0.10; breathAmp = 0.030 * breathAmpScale;
						kickRateMul = 1.18; kickHP = 200; overlayDur = 2.8;
					},
					\funny, {
						mood = \play;
						soulFreq = baseFreq + 130;
						atk=0.05; dec=0.30; sus=0.5; rel=1.25;
						lagTime = 0.20; breathAmp = 0.024 * breathAmpScale;
						kickRateMul = 1.05; kickAmpMul = 1.10; overlayDur = 3.2;
					},
					\awe, {
						mood = \awe;
						soulFreq = baseFreq + 260;
						lagTime = 0.25; breathAmp = 0.026 * breathAmpScale;
						kickRateMul = 1.10; overlayDur = 3.4;
					},
					\sad, {
						mood = \sad;
						soulFreq = baseFreq - 35;
						atk=0.08; dec=0.35; sus=0.55; rel=1.60;
						lagTime = 0.45; breathAmp = 0.020 * breathAmpScale;
						kickRateMul = 0.82; kickHP = 35; overlayDur = 4.0;
					},
					\neutral, { }
				);
			}
		);

		// Small energy drift from emotions
		if(mood == \happy) { energy = (energy + 0.15).clip(0, 1) };
		if(mood == \nervous) { energy = (energy + 0.08).clip(0, 1) };
		if(mood == \sad) { energy = (energy - 0.10).clip(0, 1) };

		// Apply overlay: breath + a few colored kicks
		this.addTimed(
			Task({
				Synth(\kickdrumBreath, [
					\out, 0,
					\amp, breathAmp,
					\soulFreq, soulFreq,
					\pan, pan,
					\lagTime, lagTime,
					\atk, atk, \dec, dec, \sus, sus, \rel, rel
				]);

				rrand(3, 7).do {
					var buf = this.getBuf;
					if(buf.notNil) { this.playKick(buf, kickRateMul, kickAmpMul, kickHP) };
					rrand(0.12, 0.45).wait;
				};
			}).play,
			overlayDur,
			0.2
		);
	}


	// =====================================================
	// RANDOMIZER: picks personal events based on EvoLab state
	// =====================================================

	randomEncounterForState { |state|
		switch(state,

			\dawn, {
				// dawn: nature + gentle curiosity
				[
					{ this.encounter(\walking, [\forest, \lake, \sea].choose) },
					{ this.encounter(\people,  [\stranger, \friend].wchoose([0.7, 0.3])) },
					{ this.encounter(\eating,  [\comfort, \bitter].wchoose([0.8, 0.2])) },
					{ this.encounter(\movie,   [\neutral, \awe].choose) }
				].wchoose([0.40, 0.25, 0.20, 0.15]).value;
			},

			\day, {
				// day: social + city movement
				[
					{ this.encounter(\people,  [\friend, \crowd, \stranger].wchoose([0.45, 0.35, 0.20])) },
					{ this.encounter(\walking, [\cityStreet, \forest, \lake].wchoose([0.55, 0.25, 0.20])) },
					{ this.encounter(\movie,   [\funny, \awe, \neutral].wchoose([0.45, 0.35, 0.20])) },
					{ this.encounter(\eating,  [\comfort, \bitter].wchoose([0.65, 0.35])) }
				].wchoose([0.35, 0.30, 0.20, 0.15]).value;
			},

			\dusk, {
				// dusk: reflective + water places
				[
					{ this.encounter(\walking, [\sea, \lake, \forest].wchoose([0.45, 0.35, 0.20])) },
					{ this.encounter(\movie,   [\sad, \neutral, \awe].wchoose([0.40, 0.35, 0.25])) },
					{ this.encounter(\people,  [\stranger, \friend].wchoose([0.75, 0.25])) },
					{ this.encounter(\eating,  [\comfort, \bitter].wchoose([0.70, 0.30])) }
				].wchoose([0.35, 0.30, 0.20, 0.15]).value;
			},

			\night, {
				// night: inner cinema + slow wandering
				[
					{ this.encounter(\movie,   [\scary, \sad, \neutral].wchoose([0.45, 0.35, 0.20])) },
					{ this.encounter(\walking, [\sea, \lake].wchoose([0.65, 0.35])) },
					{ this.encounter(\eating,  [\comfort, \bitter].wchoose([0.60, 0.40])) },
					{ this.encounter(\people,  [\stranger, \friend].wchoose([0.85, 0.15])) }
				].wchoose([0.40, 0.25, 0.20, 0.15]).value;
			},

			\danger, {
				// danger: crowd/city + fear spikes
				[
					{ this.encounter(\people,  [\crowd, \stranger, \friend].wchoose([0.55, 0.35, 0.10])) },
					{ this.encounter(\walking, [\cityStreet, \forest].wchoose([0.75, 0.25])) },
					{ this.encounter(\movie,   \scary) },
					{ this.encounter(\eating,  \bitter) }
				].wchoose([0.45, 0.35, 0.15, 0.05]).value;
			},

			{  // fallback
				this.encounter(\people, \stranger);
			}
		);
	}


	// =====================================================
	// AUTO EVENTS: ON/OFF + scheduling
	// =====================================================

	autoOn {
		autoEventsOn = true;

		// Prevent duplicates
		if(autoTask.notNil and: { autoTask.isPlaying }) { ^this };

		autoTask = Task({
			loop {
				if(autoEventsOn) { this.randomEncounterForState(currentState) };

				switch(currentState,
					\dawn,   { rrand(autoIntervalDawn[0],   autoIntervalDawn[1]).wait },
					\day,    { rrand(autoIntervalDay[0],    autoIntervalDay[1]).wait },
					\dusk,   { rrand(autoIntervalDusk[0],   autoIntervalDusk[1]).wait },
					\night,  { rrand(autoIntervalNight[0],  autoIntervalNight[1]).wait },
					\danger, { rrand(autoIntervalDanger[0], autoIntervalDanger[1]).wait },
					{ 5.wait }
				);
			}
		});

		// Track it so Creature can stop it if needed
		this.add(autoTask.play);
	}

	autoOff {
		autoEventsOn = false;
		if(autoTask.notNil) { autoTask.stop; autoTask = nil };
	}


	// =====================================================
	// MANUAL COMMAND SHORTCUTS (optional)
	// =====================================================

	people  { this.encounter(\people,  [\stranger, \friend, \crowd].choose) }
	walking { this.encounter(\walking, [\cityStreet, \forest, \lake, \sea].choose) }
	eating  { this.encounter(\eating,  [\comfort, \bitter].choose) }
	movie   { this.encounter(\movie,   [\scary, \funny, \neutral, \awe, \sad].choose) }

	stop {
		this.autoOff;
		this.release(0.5);
	}

}