/* AUD 722 _2025-2026
Final Project: EvoLab
author: Emmanouel Rovithis
last update: 01/05/26
last commit: 22/12/25
*/



Luca : Creature { // your class code here

	// stage: Dawn
	dawn {
		this.release(0.05);
		this add: {
			var env, body, soul;
			body = PlayBuf.ar(buffer.numChannels, buffer,
				// rate: [0.5, 1, 1.5].choose * BufRateScale.kr(buffer),
				rate: 1 * BufRateScale.kr(buffer),
				loop: 1,
				//doneAction: 2
			);
			//	soul = SinOsc.ar(freq: Line.kr(178, 33, 2), mul: Line.kr(0.1, 1, 3)).dup(2);
			soul = Saw.ar(Line.kr(17, 33, 10), Line.kr(0.1, 0.3, 7));
			(body * soul).adsrpan;
		}.play(outbus: spat.outbus);
	}


	// stage: Day
	day {
		this.release(0.05);
		this add: {
			var env, body, soul;
			body = PlayBuf.ar(buffer.numChannels, buffer,
				rate: Line.kr(1, 2, 9) * BufRateScale.kr(buffer),
				loop: 1,
			);
			//	soul = SinOsc.ar(freq: Line.kr(178, 33, 2), mul: Line.kr(0.1, 1, 3)).dup(2);
			soul = Saw.ar(Line.kr(33, 55, 10), Line.kr(0.3, 1, 3));
			(body * soul).adsrpan;
		}.play(outbus: spat.outbus);
	}


	// stage: Dusk
	dusk {
		this.release(0.05);
		this add: {
			var env, body, soul;
			body = PlayBuf.ar(buffer.numChannels, buffer,
				rate: Line.kr(2, 0.5, 3) * BufRateScale.kr(buffer),
				loop: 1,
			);
			soul = SinOsc.ar(Line.kr(55, 23, 10), Line.kr(1, 0.1, 7));
			(body * soul).adsrpan;
		}.play(outbus: spat.outbus);
	}


	// stage: Night
	night {
		this.release(0.05);
		this add: {
			var env, body, soul;
			body = PlayBuf.ar(buffer.numChannels, buffer,
				rate: 0.1 * BufRateScale.kr(buffer),
				loop: 1,
			);
			soul = SinOsc.ar(Line.kr(23, 11, 2), Line.kr(0.1, 0.3, 3));
			(body * soul).adsrpan;
		}.play(outbus: spat.outbus);
	}


	// stage: Danger
	danger {
		this.release(0.05);
		this add: {
			var env, body, soul;
			body = PlayBuf.ar(buffer.numChannels, buffer,
				rate: 0.1 * BufRateScale.kr(buffer),
				loop: 1,
			);
			soul = SinOsc.ar(Line.kr(11, 1, 2), Line.kr(0.3, 17, 3));
			(body * soul).adsrpan;
		}.play(outbus: spat.outbus);
	}
}