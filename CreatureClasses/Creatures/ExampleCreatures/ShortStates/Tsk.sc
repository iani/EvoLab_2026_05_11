
Tsk : Creature {
 	dawn {
		this add: {
			WhiteNoise.ar(Env.perc(~att ?? 0.01, ~rel ?? 1.0, ~amp ?? 0.1).kr(2)).dup
		}.play;
	}

	morning {
		this add: {
			Resonz.ar(
				GrayNoise.ar(Env.perc(0.01, 2).kr(0) * 0.1),
				Line.kr(Rand(50, 2000), Rand(50, 2000), 2.5)
				* SinOsc.kr(Line.kr(Rand(3, 10), Rand(3, 10), 2.5)).abs,
				0.7
			).ds(time:0.5);
		}.play;
	}
	day {
		this add: {
			PinkNoise.ar(Env.perc.kr(2) * 0.1).dup			
		}.play;
	}
	noon {
		this add: {
			Ringz.ar(Impulse.ar(0.0001),
				Line.kr(Rand(100, 4000), Rand(200, 4000), Rand(0.1, 0.9)),
				Rand(0.02, 2), 0.1).ds
		}.play;
	}
	afternoon {
		this add: {
			Mix({
				Ringz.ar(Impulse.ar(0.0001),
					Line.kr(Rand(100, 4000), Rand(200, 4000), Rand(0.1, 0.9)),
					Rand(0.02, 2), 0.03)
			} ! 3).ds
		}.play;
	}
	evening {
		this addTask: {
			3 do: {
				this.afternoon;
				0.1.wait;
			}
		};
	}
	night {
		this add: {
			Ringz.ar(Impulse.ar(0.0001), Line.kr(100, 350, 0.1) *
				(~fmul ?? { 1 }),
				0.1).ds
		}.play;
	}	
}