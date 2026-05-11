/*
EvoLab score
upd 06/05/26
*/


// version 1

(~task = EvoLab.play(
	[Luca, Talos, EvaDoudopoulou, Hive, Hum, Kickdrum, Midis, Porcupine, Staboulidis, TsabikaSouflia],   //all Creatures in the mix
	// Creatures need to be given each its own position!!  >> Iannia
	[
		dawn: 10,
		day: 10,
		dusk: 10,
		night:10,
		danger: 10  // needs to be taken out of this sequence and be triggered randomly
	],
	inf  // currently 2 EvoLab repetitions, needs to be in constant loop
)
)


// version 2
(
~task = Routine({
	loop {
		var dawnDur, dayDur, duskDur, nightDur;

		dawnDur = [10, 11, 12].wchoose([0.5, 0.4, 0.3]);
		dayDur = [20, 22, 25].wchoose([0.5, 0.4, 0.3]);
		duskDur = [10, 11, 12].wchoose([0.5, 0.4, 0.3]);
		nightDur = [20, 22, 25].wchoose([0.5, 0.4, 0.3]);

		EvoLab.play(
			[Luca, Talos, EvaDoudopoulou, Hive, Hum, Kickdrum, Midis, Porcupine, Staboulidis, TsabikaSouflia],
			[
				dawn: dawnDur,
				day: dayDur,
				dusk: duskDur,
				night: nightDur,
				danger: 10
			],
			1   // IMPORTANT: one cycle per call
		);

		(dawnDur + dayDur + duskDur + nightDur + 10).wait; // total duration of one full cycle
	}
}).play;
)


// version 3
(
~task = Routine({
	var stages = [\dawn, \day, \dusk, \night];
	var currentStage;

	currentStage = stages.choose; // random start

	loop {
		var dur;

		// --- random durations per stage ---
		dur = case
		{ currentStage == \dawn }  { [10, 11, 12].wchoose([0.5, 0.4, 0.3]) }
		{ currentStage == \day }   { [20, 22, 25].wchoose([0.5, 0.4, 0.3]) }
		{ currentStage == \dusk }  { [10, 11, 12].wchoose([0.5, 0.4, 0.3]) }
		{ currentStage == \night } { [20, 22, 25].wchoose([0.5, 0.4, 0.3]) };

		// --- play ONE stage only ---
		EvoLab.play(
			[Luca, Talos, EvaDoudopoulou, Hive, Hum, Kickdrum, Midis, Porcupine, Staboulidis, TsabikaSouflia],
	[
		dawn:  if(currentStage == \dawn)  { dur } { 0 },
		day:   if(currentStage == \day)   { dur } { 0 },
		dusk:  if(currentStage == \dusk)  { dur } { 0 },
		night: if(currentStage == \night) { dur } { 0 },
		danger: 0
	],
	1
);
		dur.wait;

		// --- possible interruption ---
		if (0.2.coin) {
			var dangerDur = [5, 8, 12].wchoose([0.5, 0.3, 0.2]);

		EvoLab.play(
			[Luca, Talos, EvaDoudopoulou, Hive, Hum, Kickdrum, Midis, Porcupine, Staboulidis, TsabikaSouflia],
	[
		dawn: 0,
		day: 0,
		dusk: 0,
		night: 0,
		danger: dangerDur
	],
	1
);

			dangerDur.wait;

			// resume from random stage
			currentStage = stages.choose;

		} {
			// normal progression
			currentStage = stages.wrapAt(stages.indexOf(currentStage) + 1);
		};
	}
}).play;
)



// version 4

(
~task = Routine({
	loop {
		var dawnDur, dayDur, duskDur, nightDur;

		dawnDur = [10, 11, 12].wchoose([0.5, 0.4, 0.3]);
		dayDur = [20, 22, 25].wchoose([0.5, 0.4, 0.3]);
		duskDur = [10, 11, 12].wchoose([0.5, 0.4, 0.3]);
		nightDur = [20, 22, 25].wchoose([0.5, 0.4, 0.3]);

		EvoLab.play(
			[Luca, Talos, EvaDoudopoulou, Hive, Hum, Kickdrum, Midis, Porcupine, Staboulidis, TsabikaSouflia],
			[
				dawn: dawnDur,
				day: dayDur,
				dusk: duskDur,
				night: nightDur,
				danger: 0
			],
			1
		);

		(dawnDur + dayDur + duskDur + nightDur).wait;
	}
}).play;

~dangerTask = Routine({
	loop {
		var waitTime, dangerDur;

		waitTime = rrand(100, 140); // time between dangers
		waitTime.wait;

		dangerDur = [5, 8, 12].wchoose([0.5, 0.3, 0.2]);

		EvoLab.play(
			[Luca, Talos, EvaDoudopoulou, Hive, Hum, Kickdrum, Midis, Porcupine, Staboulidis, TsabikaSouflia],
			[
				dawn: 0,
				day: 0,
				dusk: 0,
				night: 0,
				danger: dangerDur
			],
			1
		);

		dangerDur.wait;
	}
}).play;
)

// version 5

(
~task = Routine({

	var stages, currentStage;
	var dur, dangerDur;

	stages = [\dawn, \day, \dusk, \night];
	currentStage = stages.choose;

	loop {

		// ---------------- NORMAL STAGE ----------------

		dur = case
		{ currentStage == \dawn }  { [10,11,12].wchoose([0.5,0.4,0.3]) }
		{ currentStage == \day }   { [20,22,25].wchoose([0.5,0.4,0.3]) }
		{ currentStage == \dusk }  { [10,11,12].wchoose([0.5,0.4,0.3]) }
		{ currentStage == \night } { [20,22,25].wchoose([0.5,0.4,0.3]) };

		// stop previous EvoLab instance
		~evo.notNil.if {
			~evo.stop;
		};

		// launch new stage
		~evo = EvoLab.play(
			[
				Luca, Talos, EvaDoudopoulou, Hive, Hum,
				Kickdrum, Midis, Porcupine,
				Staboulidis, TsabikaSouflia
			],

			[
				dawn: if(currentStage == \dawn) { dur },
				day: if(currentStage == \day) { dur },
				dusk: if(currentStage == \dusk) { dur },
				night: if(currentStage == \night) { dur }
			],

			1
		);

		dur.wait;

		// ---------------- DANGER INTERRUPTION ----------------

		if(0.2.coin) {

			dangerDur = [5,8,12].wchoose([0.5,0.3,0.2]);

			// stop current stage
			~evo.notNil.if {
				~evo.stop;
			};

			// launch danger
			~evo = EvoLab.play(
				[
					Luca, Talos, EvaDoudopoulou, Hive, Hum,
					Kickdrum, Midis, Porcupine,
					Staboulidis, TsabikaSouflia
				],

				[
					danger: dangerDur
				],

				1
			);

			dangerDur.wait;

			// resume from random stage
			currentStage = stages.choose;

		} {

			// normal cyclic progression
			currentStage = stages.wrapAt(
				stages.indexOf(currentStage) + 1
			);

		};

	};

}).play;
)

// version 6 let's step back
(
~task = Routine({
	loop {
		var dawnDur, dayDur, duskDur, nightDur;

		dawnDur = [10, 11, 12].wchoose([0.5, 0.4, 0.3]);
		dayDur = [20, 22, 25].wchoose([0.5, 0.4, 0.3]);
		duskDur = [10, 11, 12].wchoose([0.5, 0.4, 0.3]);
		nightDur = [20, 22, 25].wchoose([0.5, 0.4, 0.3]);

		EvoLab.play(
			[Luca, Talos, EvaDoudopoulou, Hive, Hum, Kickdrum, Midis, Porcupine, Staboulidis, TsabikaSouflia],
			[
				dawn: dawnDur,
				day: dayDur,
				dusk: duskDur,
				night: nightDur,
			],
			1   // IMPORTANT: one cycle per call
		);

		(dawnDur + dayDur + duskDur + nightDur).wait; // total duration of one full cycle
	}
}).play;
)

// version 7

(
//////////////////////////////////////////////////
// NORMAL CYCLE ROUTINE
//////////////////////////////////////////////////

~normalCycle = {

	Routine({

		loop {

			var dawnDur, dayDur, duskDur, nightDur;

			dawnDur = [10,11,12].wchoose([0.5,0.4,0.3]);
			dayDur = [20,22,25].wchoose([0.5,0.4,0.3]);
			duskDur = [10,11,12].wchoose([0.5,0.4,0.3]);
			nightDur = [20,22,25].wchoose([0.5,0.4,0.3]);

			~evo = EvoLab.play(

				[
					Luca, Talos, EvaDoudopoulou, Hive, Hum,
					Kickdrum, Midis, Porcupine,
					Staboulidis, TsabikaSouflia
				],

				[
					dawn: dawnDur,
					day: dayDur,
					dusk: duskDur,
					night: nightDur
				],

				1
			);

			(dawnDur + dayDur + duskDur + nightDur).wait;

		}

	});

};

//////////////////////////////////////////////////
// START NORMAL CYCLE
//////////////////////////////////////////////////

~mainTask = ~normalCycle.value.play;

//////////////////////////////////////////////////
// DANGER ROUTINE
//////////////////////////////////////////////////

~dangerTask = Routine({

	loop {

		var waitTime, dangerDur;

		// random time before danger appears
		waitTime = rrand(30, 90);

		waitTime.wait;

		// STOP current normal cycle
		~mainTask.stop;

		~evo.notNil.if {
			~evo.stop;
		};

		// random danger duration
		dangerDur = [5,8,12].wchoose([0.5,0.3,0.2]);

		// PLAY danger
		~evo = EvoLab.play(

			[
				Luca, Talos, EvaDoudopoulou, Hive, Hum,
				Kickdrum, Midis, Porcupine,
				Staboulidis, TsabikaSouflia
			],

			[
				danger: dangerDur
			],

			1
		);

		dangerDur.wait;

		// stop danger
		~evo.notNil.if {
			~evo.stop;
		};

		// restart normal cycle
		~mainTask = ~normalCycle.value.play;

	}

}).play;
)
