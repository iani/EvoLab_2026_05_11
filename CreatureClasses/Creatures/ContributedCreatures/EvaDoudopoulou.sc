/*
Minimal example of a Creature class.

States to be implemented are:

dawn
day
dusk
night
danger
*/

EvaDoudopoulou : Creature { // Creatures must be subclasses of Creature

	// define one method for each state
	// any states that do not have a method will remain silent (play nothing).

	dawn { //pending
		 this.substitute(
        {
			// var src;
			// src = PinkNoise.ar(0.05 ! 2) * Env.perc(0.1, 5).kr(2);
			// PanAz.ar(4, src, LFNoise2.kr(1/10).range(-1, 1));
			PinkNoise.ar(0.05 ! 2) * Env.perc(0.1, 5).kr(2);
		}.play,
			releaseTime: 6);
	}

	day { //done (ripoff)
		"EvaDoudopoulou: day".postln;
		this substitute:
		{ var sig = GrainBuf.ar(
            numChannels: 2,
            trigger: Impulse.ar(10),
            dur: 0.1,
            sndbuf: this.buffer,
            rate: 0.7,
            pos: LFNoise1.kr(0.2).range(0, 1),
            interp: 4,
            pan: LFNoise2.kr(0.5),
            maxGrains: 256
        );
        sig * 0.7;
		}.play;
	}

	dusk { //done
		"EvaDoudopoulou: night".postln;
		this substitute: {
		var freqenv, sine0, sine1;
		freqenv = Line.kr(1,0,5);
			sine0 = SinOsc.ar(400*freqenv, mul: 0.1).dup;
			sine1 = SinOsc.ar(396*freqenv, mul: 0.1).dup;
			(sine0 + sine1);
		}.play;
		{this.release(5)} defer: 3; //let's talk about this!
	}

	night {
		// this.release(5);
		// peaceful silence (high concept)
	}

	danger { //done

		"EvaDoudopoulou: danger".postln;

		 this substitute: { | buf |
	var env, playbuf, playsine0, playsine1, playsine2 ;
	env = Env.adsr(2, 1);
	playbuf = PlayBuf.ar(buf.numChannels,
		EvaDoudopoulou.buffer, loop: 1).dup(2);
	playsine0 = SinOsc.ar(72)*3.dup(2);
	playsine1 = SinOsc.ar(111)*2.dup(2);
    playsine2 = SinOsc.ar(102)*2.dup(2);
	(playbuf * playsine0 * playsine1 * playsine2) *env.kr;
		}.play;

	}
}