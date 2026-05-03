/* AUD 722 _2025-2026
Final Project: Sound Creature
author: Emmanouel Rovithis
last update: 22/12/25
last commit: 22/12/25
*/

s.boot;
s.reboot;

/* ============================================================
Initialization
*/

(
s.waitForBoot({
    // -------- SET PATH --------
	// search for .wavs in the designated path
	var audioPath = "~/Documents/IONIO/ΜΑΘΗΜΑΤΑ/Μουσική Πληροφορική/code_AUD722_25-26/audio/*.wav";

    // -------- LOAD BUFFER --------
	// Make buffer(s) and store file(s) in the current environment

    audioPath.standardizePath.pathMatch do: { |p|
        currentEnvironment.put(
            PathName(p).fileNameWithoutExtension.asSymbol,
            Buffer.read(Server.default, p, action: {
	        ("Loaded buffer " ++ PathName(p).fileNameWithoutExtension.asSymbol ++ " from: " ++ p).postln;
            })
        );
    };
});
)


// Test-play
~emro722mono.play;
// Test in stereo
{ PlayBuf.ar(1, ~emro722mono).dup(2)}.play;


/* ============================================================
Create the Creature_
_set Body and Soul
*/

(
f = { | buf, rate = 1 |
	PlayBuf.ar(buf.numChannels, buf, rate * BufRateScale.kr(buf), loop: 0).dup(2);
};
)

// play independently
(
~myBody = f.play(args: [buf: ~emro722mono]);
)
(
~mySoul = { SinOsc.ar(178, 0, 0.2).dup(2); }.play;
)

// stop independently
~myBody.release;
~mySoul.release;


/*
_connect Body and Soul
_give "breath" shape
*/

//  perform ring modulation + apply amp envelope
(
~cfbrm = {
	var env, body, soul;
	env = Env([0, 1, 0.3, 0], [0.1, 2.5, 2]); // Atk, Dec, Rel
	body = PlayBuf.ar(~emro722mono.numChannels, ~emro722mono, rate: 1, loop: 0).dup(2);
	soul = SinOsc.ar(178, 0, 0.5).dup(2);
	(body * soul) * env.kr(doneAction: 2);
};
)


// play
~cfbrm.play;


/*
_Mutations_01:
. "richer" Soul (sawtooth),
. line envelope in ring modulation,
. variable playback rate with uniform randomness
*/


(
~cfbrm01 = {
	var env, body, soul;
	env = Env([0, 1, 0.3, 0], [0.1, 2.5, 2]); // Atk, Dec, Rel
	body = PlayBuf.ar(~emro722mono.numChannels, ~emro722mono, rate: [0.5, 1, 1.5].choose, loop: 0).dup(2);
//	soul = SinOsc.ar(freq: Line.kr(178, 33, 2), mul: Line.kr(0.1, 1, 3)).dup(2);
	soul = Saw.ar(Line.kr(178, 33, 2), Line.kr(0.1, 1, 3)).dup(2);
	(body * soul) * env.kr(doneAction: 2);
};
)

// play mutant01
~cfbrm01.play;


/*
_Mutation_02:
. envelope (shorter Atk, longer Dec)
. playback rate with weighted randomness
. FM on Ring Modulator
*/

(
~cfbrm02 = {
	arg modulatorFreq = 4, index = 1;
	var env, body, soul, depth;
	env = Env([0, 1, 0.3, 0], [0.01, 4, 4]); // Atk, Dec, Rel
	body = PlayBuf.ar(~emro722mono.numChannels, ~emro722mono, rate: [0.1, 0.5].wchoose([0.7, 0.3]);, loop: 0).dup(2);
	depth = modulatorFreq * index;
	soul = Saw.ar(Line.kr(178, 33, 2) + SinOsc.ar(modulatorFreq, mul: depth), Line.kr(0.1, 1, 3)).dup(2);
	(body * soul) * env.kr(doneAction: 2);
};
)

// play mutant02
~cfbrm02.play(args: [modulatorFreq: 33, index: 44]);
~cfbrm02.play(args: [modulatorFreq: 33, index: 4]);
~cfbrm02.play(args: [modulatorFreq: 4, index: 44]);


/*
_Mutation_03
_Evolution into SynthDef !!!
*/









/* ============================================================
Control the Creature_
*/

// play
~cfrm2.play;

// playback 4 times + random selection of time interval
(
~metro = Routine({
    4.do {
        ~cfrm2.play;
        [6, 8, 10].choose.wait;
		// 5.wait;
    }
}).play;
)

// play forever until stopped
(
~metro = Routine({
    loop {
        ~cfrm2.play;
        2.wait;
    }
}).play;
)

~metro.stop;



/*
play without EnvGen + gate
~myCreature = ~cfrm.play;
stop
~myCreature.release(3);
*/


startSynth {
	if (synth.isRunning.not) {
		// put your synth function here
		synth = {
		// put your synth function here
		}.play;
		synth.isRunning = true
		synth.register;
    }
}


day {
	this.startSynth(freq: 600, rate: 0.5);
}

hunt {

}








