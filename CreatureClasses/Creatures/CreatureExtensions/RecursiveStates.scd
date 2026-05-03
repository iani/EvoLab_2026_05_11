Pbind(
	\state, Pseq([\idle, \active, \sleep], inf),
	\play, { ~state.postln}
).play;