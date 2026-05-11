Staboulidis : Creature {

	// Μια βοηθητική μέθοδος για να μην γράφουμε τον ίδιο κώδικα παντού
	// Εδώ γίνεται το Ring Modulation (Body * Soul)
	makeSound { |rate = 1, modFreq = 440, dur = 5|
		this.substitute({
			var body, soul, env;

			// 1. Amplitude Envelope
			env = EnvGen.kr(Env.linen(0.1, dur - 0.2, 0.1), doneAction: 2);

			// 2. Body (Buffer με Playback Rate)
			body = PlayBuf.ar(2, buffer.bufnum, BufRateScale.kr(buffer.bufnum) * rate, loop: 1);

			// 3. Soul (Sinewave Modulator)
			soul = SinOsc.ar(modFreq);

			// 4. Ring Modulation
			(body * soul * env * 0.5);
		}.play(outbus: spat.outbus));
	}

	dawn {
		"Morning state".postln;
		this.makeSound(rate: 1.2, modFreq: 800, dur: 5);
	}

	/* noon {
		"Noon state".postln;
		this.makeSound(rate: 0.8, modFreq: 300, dur: 3);
	}*/

	day {
		"Day state".postln;
		this.makeSound(rate: 1.0, modFreq: 500, dur: 6);
	}

	dusk {
		"Afternoon state".postln;
		this.makeSound(rate: 0.9, modFreq: 400, dur: 4);
	}

	/* evening {
		"Evening state".postln;
		this.makeSound(rate: 0.7, modFreq: 200, dur: 3);
	}*/

	night {
		"Night state - Sleep".postln;
		this.release(4);
	}
}

/*
(
~task = EvoLab.play(
    [Staboulidis],
    [
        morning: 5,
        noon: 3,
        day: 6,
        afternoon: 4,
        evening: 3,
        night: 5
    ],
    2
);
)
*/