/*

States to be implemented are:

dawn
day
dusk
night
danger

*/
//06.02.2026
//Contribution Creature by Ruben Labes (avaer2025003)

Hum : Creature { // Creatures must be subclasses of Creature

	// define one method for each state
	// any states that do not have a method will remain silent (play nothing).

	dawn {
		this substitute: {
			(Ringz.ar(PlayBuf.ar(buffer.numChannels, Hum.buffer, rate: Line.kr(-0.8, -5, 5) * BufRateScale.kr(buffer),loop: 1, doneAction: 2), freq:  Line.kr(1000, 7000, 7), decaytime: 3, mul: 0.3)).dup
			//BHiPass.ar(PlayBuf.ar(buffer.numChannels, Hum.buffer, rate: -1, loop: 1, doneAction: 2), Line.kr(1000, 4000, 5), 0.71, 0.5).dup;
		}.play;
	}

	day {
		this release: 10;
		this add: {
			BHiPass.ar((PlayBuf.ar(buffer.numChannels, Hum.buffer , rate: [-0.5, -1, -2].choose * BufRateScale.kr(buffer), loop: 1 , doneAction: 2).dup), freq: 200, rq: 0.71, mul: 1.0)
			+
			(BBandPass.ar(Saw.ar(100, mul: 0.3), freq: Line.kr(100, 5000, 10), bw: 0.71, mul: 0.5))
			+
			(BBandPass.ar(Saw.ar(150, mul: 0.3), freq: Line.kr(300, 500, 10), bw: 0.71, mul: 0.5))
			;
		}.play;
	}

	dusk {
		this release: 5.5;
		this add: { PlayBuf.ar(buffer.numChannels, Hum.buffer,
				rate: [0.2, 0.4, 0.6].choose * BufRateScale.kr(buffer),
				loop: 0,
				doneAction: 2
			) * BLowPass.ar(SyncSaw.ar(500, 200, 0.3).dup, 500, 0.71, 0.3).dup }.play;
	}

	night {
		this release: 0.5;
		this add: {
			(PlayBuf.ar(buffer.numChannels, Hum.buffer, rate: 1.2, loop: 1, doneAction: 0) * PlayBuf.ar(buffer.numChannels, Hum.buffer, rate: 0.8, loop: 0, doneAction: 0)).dup
		}.play
	}

	danger {
		this release: 1.5;
		this add: {
			BBandPass.ar(WhiteNoise.ar(mul: 1), freq: Line.kr(20000, 20, 0.5), bw: 0.5, mul: 0.8).dup
			*
			BBandPass.ar(Saw.ar(mul: 1), freq: Line.kr(2000, 200, 0.5), bw: 0.5, mul: 0.8).dup
		}.play
	}
}