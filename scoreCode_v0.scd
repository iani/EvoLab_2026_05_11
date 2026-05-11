(~task = EvoLab.play(
	[Luca, Talos, EvaDoudopoulou, Hive, Hum, Kickdrum, Midis, Porcupine, Staboulidis, TsabikaSouflia],   //all Creatures in the mix
	// Creatures need to be given each its own space!!
	[
		// dawn: 10,
		dawn: [10, 15, 20].wchoose([0.4, 0.3, 0.5]), //weight different stage durations
		day: 10,
		dusk: 10,
		night:10,
		danger: 10  // needs to be taken out of this sequence and be triggered randomly
	],
	2  // currently 2 EvoLab repetitions, needs to be in constant loop
)
)