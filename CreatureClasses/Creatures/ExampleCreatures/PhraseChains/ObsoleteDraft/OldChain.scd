// 土 20 12 2025 14:35
// Prototype for playing patterns as chains. See About_Chains.md


Chain : Creature {
	//============================================================
	// chaining phrases.
	// Alternative method that calculates the duration based on the
	// values returned by each method. This method relies on direct
	// method call to obtain the duration return value. Controllers are not used.

	// prototype 1
	chain1 { | pattern |
		^Pbind(
			\chain, pattern,
			\play, {
				// ~chain.postln;
				~dur = this.perform(*~chain);
			}
		).play;
	}
	// prototype 0
	chain0 { | pattern |
		pattern = pattern.asStream;
		^Task({
			var method, dur;
			while {
				(method = pattern.next).notNil
			}{
				dur = this.perform(*method) ? 0;
				dur.wait;
			};
			"pattern finished".postln;
		}).play;
	}

	phrase1 { | pattern |
		// incomplete. modeling this in file Chain.scd
		thisMethod.name.postln;
		^1;
	}

	phrase2 { | pattern |
		// incomplete. modeling this in file Chain.scd
		thisMethod.name.postln;
		^0.5;
	}
	
	// draft. 
	p { | dur = 2 |  // pause
		~dur;
	}

	// sound event methods
 	dawn { | att = 0.01, rel = 1.0 |
		att = ~att ?? att;
		rel = ~rel ?? rel;
		this add: {
			WhiteNoise.ar(Env.perc(att, rel, ~amp ?? 0.1).kr(2)).dup
		}.play;
		^att + rel
	}

	morning {
		this add: {
			Resonz.ar(
				GrayNoise.ar(Env.perc(0.01, 2).kr(0) * 0.1),
				Line.kr(Rand(50, 2000), Rand(50, 2000), 2.5)
				* SinOsc.kr(Line.kr(Rand(3, 10), Rand(3, 10), 2.5)).abs,
				0.7
			).ds(time:0.5);
		}.play;
		^3;
	}
	day {
		this add: {
			PinkNoise.ar(Env.perc.kr(2) * 0.1).dup			
		}.play;
		^1.0
	}
	noon {
		this add: {
			Ringz.ar(Impulse.ar(0.0001),
				Line.kr(Rand(100, 4000), Rand(200, 4000), Rand(0.1, 0.9)),
				Rand(0.02, 2), 0.1).ds
		}.play;
	}
	afternoon {
		this add: {
			Mix({
				Ringz.ar(Impulse.ar(0.0001),
					Line.kr(Rand(100, 4000), Rand(200, 4000), Rand(0.1, 0.9)),
					Rand(0.02, 2), 0.03)
			} ! 3).ds
		}.play;
	}
	evening {
		this addTask: {
			3 do: {
				this.afternoon;
				0.1.wait;
			}
		};
	}
	night {
		this add: {
			Ringz.ar(Impulse.ar(0.0001), Line.kr(100, 350, 0.1) *
				(~fmul ?? { 1 }),
				0.1).ds
		}.play;
		^0.1
	}	

	// testing subphrases
	blurb {
		^Pseq([\dawn, \day, [\dawn, 0.02, 0.05], \morning], 2)
	}
}