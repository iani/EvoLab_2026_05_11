
f = { | ... args | args.postln; };
f.update;
//:
e = Pbind(
	\state, Pseq([\dawn], 1),
	\play, { ~state.postln },
	\dur, Pn(1, 1);
).play;
//:
e.stop;
//:
c = Cricket();
c addModel: \x;
//:
e = Pbind(
	\state, Pseq([\dawn], 1),
	\play, { ~state.postln; \x changed: ~state },
	\dur, 0.1
).play;
//:
c.play;
//:
c = Cricket();
c addModel: c;
c changed: \dawn;
c.changed(\release, 0.5);
//:
c = Cricket();
c.pbindPlay(Pseq([\dawn], 1), 1000);
//:
c play: \dawn;
