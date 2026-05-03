Porcupine : Creature {
    *fileName { ^"porcupine.wav" }

    *addSynthDefs {
        SynthDef(\porcupine, {

			arg buf, freq=220,
		       attack=0.2, decay=0.2, sustain=0.8, release=0.1,
			    out = 0, gate = 1,
			    rate=1,
			    lfoRate = 2, minMul = 0, maxMul = 0.8;

			var env, body, soul, finalSignal, lfoMul;

			lfoMul = LFSaw.kr(lfoRate).range(minMul, maxMul);

			env = EnvGen.kr(
				Env.adsr(attack, decay, sustain, release),
			   gate: gate,
				doneAction: 2
			);
			body = PlayBuf.ar(buf.numChannels, buf, rate: rate, loop: 1);
			soul = SinOsc.ar(freq, 0, lfoMul);

			finalSignal = (body * soul) * env;

			Out.ar(out, Pan2.ar(finalSignal, 0));

        }).add;
    }

   dawn {

		 // *** dawn breath
        this.substitute(
            Synth(\porcupine, [
                \buf, this.buffer,
                \freq, 200,
                \rate, 2,
                \lfoRate, 1.5,
                \minMul, 0.1,
                \maxMul, 0.7
            ])
        );
       // *** dawn voice
		  this addLoop: {
			    [4, 8, 12].choose.wait;
			    this.addTimed (
				  {SinOsc.ar(LFNoise1.kr(1).range(1200, 1600), 0, 0.1) *
					Line.kr(0,1,0.5).dup
				  }.play,
				  [1, 2, 3].choose
			    );
		 }
	}

	day {
        // *** day breath
        this.substitute(
            Synth(\porcupine, [
                \buf, this.buffer,
                \freq, 440,
                \rate, 1.5,
                \lfoRate, 0.8,
                \minMul, 0.05,
                \maxMul, 1
            ])
        );
		  // *** day voice
		  this addLoop: {
			    [5, 8].choose.wait;
			    this.addTimed ({
				      LFSaw.ar(LFNoise2.kr(2).range(100, 400)) *
					   EnvGen.kr(
					       Env.perc(0.5, 0.8, [0.03, 0.1, 0.17].choose),
						    doneAction:2
				      ).dup
				  }.play,
				  3
			    );
		 }
    }

	 dusk {
        // *** dusk breath
        this.substitute(
            Synth(\porcupine, [
                \buf, this.buffer,
                \freq, 660,
                \rate, 1,
                \lfoRate, 0.5,
                \minMul, 0.03,
                \maxMul, 0.8
            ])
        );
		 // *** dusk voice
       this add: {
			GrayNoise.ar(LFNoise1.kr(0.1) * 0.01).dup
		 }.play;
	}


    night {
        // *** night breath
		  this.substitute(
            Synth(\porcupine, [
                \buf, this.buffer,
                \freq, 880,
                \rate, 0.5,
                \lfoRate, 0.3,
                \minMul, 0,
                \maxMul, 0.4
            ])
        );
		 // *** night voice
       this add: {
			LFNoise0.ar(LFNoise1.kr(2).range(200, 400), 0.01).dup
		 }.play;
    }

	danger {
		  this.substitute(
            Synth(\porcupine, [
                \buf, this.buffer,
                \freq, 1220,
                \rate, 3,
                \lfoRate, 2,
                \minMul, 0.4,
                \maxMul, 1
            ])
        );
    }

}