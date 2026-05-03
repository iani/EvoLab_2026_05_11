// After <2025-12-20 土> this is the classto use
// for running simulations on a group of creatures.

EvoLab {
	classvar default;   // the default instance.
	var <>creatures;
	// easy testing of instance methods dawn, day, etc.
	*doesNotUnderstand { | selector ... args |
		^this.default.perform(selector, *args);
	}

	*default {
		default ?? { default = this.new };
		^default;
	}

	play { | argCreatures, statesDurs, repeats = 1 |
		var states, durs;
		creatures = argCreatures.asArray;
		#states, durs = statesDurs.clump(2).flop;
		^Pbind(
			\state, Pseq(states, repeats),
			\dur, Pseq(durs, repeats),
			\play, {
				postln("Playing state" + ~state + "for" + ~dur + "seconds");
				creatures do: { | c | c.performAction(*~state) }
			}
		).play;
	}

	*release { | dur | this.default.release(dur) }
	release { | dur = 0.02 |
		creatures do: { | c | c release: dur }
	}
}