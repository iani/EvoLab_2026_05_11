// version 7

(
//////////////////////////////////////////////////
// NORMAL CYCLE ROUTINE
//////////////////////////////////////////////////

~evo = EvoLab.play(

	[
		Luca, Talos, EvaDoudopoulou, Hive, Hum,
		Kickdrum, Midis, Porcupine,
		Staboulidis, TsabikaSouflia
	],

	[
		dawn: Pfuncn({ [10,11,12].wchoose([0.5,0.4,0.3]) }, 1),
		day: Pfuncn({ [20,22,25].wchoose([0.5,0.4,0.3]) }, 1)
		dusk: Pfuncn({ [10,11,12].wchoose([0.5,0.4,0.3]) }, 1),
		night: Pfuncn({ [20,22,25].wchoose([0.5,0.4,0.3]) }, 1)
	],
	inf
);


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
					dawn: Pfuncn({ [10,11,12].wchoose([0.5,0.4,0.3]) }, 1),
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
