+ UGen {
	adsr { | envAmp = 1 |
		^this * Env.adsr(0.01, 0.3, 1, 1).kr(2, \gate.kr(1)) * envAmp;
	}

	adsrpan { | envAmp = 1 |
		^Pan2.ar(this.adsr(envAmp), \pos.kr(0), \level.kr(1))
	}
	
	adsraz { | envAmp = 1, numChans = 4 |
		^PanAz.ar(numChans, this.adsr(envAmp),
			\pos.kr(0), \level.kr(1), \width.kr(2), \orientation.kr(0.5)
		)
	}
}