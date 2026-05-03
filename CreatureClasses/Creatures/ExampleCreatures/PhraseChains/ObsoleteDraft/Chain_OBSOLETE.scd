// 土 20 12 2025 13:20
//: Preparing testing of Chain sound methods
Chain.dawn;
Chain.dawn(2, 5)
//: First test of new implementation
Chain.chain1(Pseq([\dawn, [\dawn, 2, 5]], 2));
Chain.chain1(Pseq([\dawn, \day, [\dawn, 2, 5], \morning], 2));

Chain.chain1(Pseq([\night, Pseq([\dawn, \day, [\dawn, 2, 5], \morning], 2)], inf));

Chain.chain1(Pseq([\night, Chain.blurb], inf));

Chain.night;
//:-------------------------------------------------- 
// Earlier coding experiments 
//: good starting point for process:
Pbind(\chain, Pseq((1..10)), \play, { ~chain.postln; ~dur = 0.1 }).play;
//:
f = { | player, pattern |
	// pattern = pattern.asStream;
	^Pbind(
		\chain, pattern,
		\play, {
			~chain.postln;
			~dur = player.perform(*~chain);
		}
	).play;
};
//:
f.(Creature(), Pseq([\phrase1, \phrase2], 2));
//:
Creature().chain(Pseq([\phrase1, \phrase2], 2));
Creature().chain(Prand([\phrase1, \phrase2], 5));

//: ----- Older ------
//: Developing an implementation of the chaining idea described in About_Chains.md
f = { | player, pattern |
	pattern = pattern.asStream;
	^Task({
		var method, dur;
		while {
			(method = pattern.next).notNil
		}{
			dur = player.perform(method) ? 0;
			dur.wait;
		};
		"pattern finished".postln;
	}).play;
};
//:
f.(Creature(), Pseq([\phrase1, \phrase2]));
//:	Testing prototype
Creature().chain(Pseq([\phrase1, \phrase2]));
Creature().chain(Pseq([\phrase1, \phrase2], 2));
Creature().chain(Prand([\phrase1, \phrase2], 5));
//: