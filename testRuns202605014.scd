//:
~task = EvoLab.play(
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
//:
EvoLab.stop;

//:
~task = EvoLab.play(
	[Luca],   //all Creatures in the mix
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
