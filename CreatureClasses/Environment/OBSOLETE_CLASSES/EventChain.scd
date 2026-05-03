// extend Event so that it can play event chains using the same mechanism
// as implemented in class Chain.
+ Event {
	chain { | pattern |
		^this use: {
			^Pbind(
				\chain, pattern,
				\play, {
					~dur = this[~chain.asArray.first]
					.value(*(~chain.asArray[1..]));
				}
			).play;
		}
	}
} 