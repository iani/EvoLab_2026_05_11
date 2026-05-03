// Creature by Emmanouil Rovithis
Emro : Creature {
	test { buffer.postln; buffer.play }

	testBuffer {
		this release: 0.5;
		this add: {
			PlayBuf.ar(Buffer.numChannels, buffer,
				BufRateScale.kr(buffer),
				loop: 1, doneAction: 2
			).adsrpan;
		}.play;
	}
	day {
		this release: 0.5;
		this add: {
			var env, body, soul;
			body = PlayBuf.ar(buffer.numChannels, buffer,
				rate: [0.5, 1, 1.5].choose * BufRateScale.kr(buffer),
				loop: 0,
				doneAction: 2
			);
			//	soul = SinOsc.ar(freq: Line.kr(178, 33, 2), mul: Line.kr(0.1, 1, 3)).dup(2);
			soul = Saw.ar(Line.kr(178, 33, 2), Line.kr(0.1, 1, 3));
			(body * soul).adsrpan;
		}.play;
	}

	night {
		this release: 0.5;
		this add: {
			arg modulatorFreq = 4, index = 1;
			var env, body, soul, depth;
			env = Env([0, 1, 0.3, 0], [0.01, 4, 4]); // Atk, Dec, Rel
			body = PlayBuf.ar(buffer.numChannels, buffer,
				rate: [0.1, 0.5].wchoose([0.7, 0.3]) * BufRateScale.kr(buffer),
				loop: 0);
			depth = modulatorFreq * index;
			soul = Saw.ar(Line.kr(178, 33, 2) +
				SinOsc.ar(modulatorFreq, mul: depth),
				Line.kr(0.1, 1, 3));
			(body * soul * env.kr(doneAction: 2)).adsrpan;
		}.play;
	}
}