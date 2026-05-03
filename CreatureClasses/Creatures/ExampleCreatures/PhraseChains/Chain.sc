// New version of chain:
// Plays sounds and chains provided in an event.
// Does not require recompile

Chain {
	var <>sounds;
	*new { | sounds | ^this.newCopyArgs(sounds) }
	play { | pattern |
		^Pbind(
			\chain, pattern,
			\play, {
				~dur = sounds[~chain.asArray.first]
				.value(*(~chain.asArray[1..]));
			}
		).play;

	}
}