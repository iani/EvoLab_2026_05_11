// Αρχείο wav.

~b0 = Buffer.read(s, "C:/Users/User/Desktop/audiofiles/Higurashi Rena & Mion psycho laugh @ambien.wav");
~b0.play;

// Δημιουργία Synthdef για τον συνδυασμό ring modulation, playback rate, amplitude envelope.

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

	//Επιλογή 2 καναλιών ήχου
	Out.ar(0, (sig * env)!2);
}).add;

// Αναπαραγωγή.

x = Synth(\mixTest, [\buf, ~b0]);

x.set(\atk, 1.5);

Env.linen(0.2, 0.3, 1).plot;




