// utility for stopping a synth when it becomes very soft.
+ UGen {
	ds { | amp = 0.001, time = 0.1, doneAction = 2 |
		DetectSilence.ar(this, amp, time, doneAction);
		this
    }
}
