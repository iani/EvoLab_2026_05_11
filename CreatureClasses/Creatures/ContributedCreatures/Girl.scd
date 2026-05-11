// Creature by Ilias ...
Girl : Creature {

	*addSynthDefs {
		SynthDef(\mixTest, { |buf, atk = 0.2, rel = 1, rate = 1, modFreq = 400|
			var samp, tone, env, sig;

			//Sample ΄κ προθήκη playback rate.
			samp = PlayBuf.ar(1,buf, rate, 1,  loop: 1);

			// Sine wave για ring modulation.
			tone = SinOsc.ar(modFreq, 0, 1);
			sig = samp * tone;

			// Envelope (επεξεργασία της αττάκας και της ουράς.
			env = EnvGen.kr(
				Env.linen(atk, 0.3, rel).circle,
				gate: 1,
				doneAction: 0
			);
			// Correction; add adsr env to enable release 
			Out.ar(0, (sig * env * Env.adsr.kr(2, \gate.kr(1))) ! 2);
		}).add;
	}

	day {
		this release: 0.5;
		this add: Synth(\mixTest, [buf: Girl.buffer.bufnum]);
	}

	night {
		this release: 0.5;
		this add: Synth(\mixTest, [buf: Girl.buffer.bufnum, rate: 0.3]);
	}
}