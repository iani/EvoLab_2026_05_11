// After <2025-12-20 土> this is the classto use
// for running simulations on a group of creatures.

EvoLab {
	classvar default;   // the default instance.
	var <>creatures, <statePattern, <dangerRoutine;
	var <>dangerInterval;
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
		this.startDangerRoutine;
		statePattern = Pbind(
			\state, Pseq(states collect: _.asStream, repeats),
			\dur, Pseq(durs collect: _.asStream, repeats),
			\play, {
				postln("Playing state" + ~state + "for" + ~dur + "seconds");
				creatures do: { | c | c.performAction(*~state) }
			}
		).play;
		^statePattern;
	}

	startDangerRoutine {
		dangerInterval ?? { 60 * 4 };
		dangerRoutine = {
			loop {
				dangerInterval.next.wait;
				"!!!!!!!!!!!!!!!!! DANGER !!!!!!!!!!!!!!!".postln;
				creatures do: { | c | c.performAction(\danger) }
			}
		}.fork;
	}

	*stop { this.default.stop }
	stop {
		statePattern.stop;
		dangerRoutine.stop;
	}
	
	*release { | dur | this.default.release(dur) }
	release { | dur = 0.02 |
		creatures do: { | c | c release: dur }
	}
}