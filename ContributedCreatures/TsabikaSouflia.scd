TsabikaSouflia : Creature {
	dawn {
		   "TsabikaSouflia: Dawn".postln;
		this.add(
			{
				var body, soul, env, lfo;
				body = PlayBuf.ar(buffer.numChannels, buffer, rate: 0.6, loop: 1);
				soul = SinOsc.ar(60);
				env = Env.asr(8, 1, 4).kr(2, gate: 1);
				lfo = SinOsc.kr(0.2).range(0.3,0.7);

				(body * soul * env * lfo * 0.4).dup;
			}.play(outbus: spat.outbus);
		)
	   }


	day {
			"TsabikaSouflia: Day".postln;
		this.substitute(
			{
				( PlayBuf.ar(buffer.numChannels, buffer, 1.0, loop: 1) *
					SinOsc.ar(178) * Env.adsr(0.5, 0.2, 0.8, 2).kr(2, gate: 1)
					* 0.5).dup;
			}.play(outbus: spat.outbus);
		)
		 }


	dusk {
		   "TsabikaSouflia: Dusk".postln;
		this.substitute(
			{
				var src;
				src = LPF.ar(PlayBuf.ar(buffer.numChannels, buffer, 0.8, loop: 1) *
					SinOsc.ar(125) * Env.asr(2, 1, 10).kr(2, gate: 1));
				src.dup;
				// Line.kr(4000, 250, 10) * 0.4).dup;
			}.play(outbus: spat.outbus);
		)
	  }


	night {
		    "TsabikaSouflia: Night".postln;
		this.substitute(
			{
				(PlayBuf.ar(buffer.numChannels, buffer, 0.4, loop: 0)
					* SinOsc.ar(40) * Env.perc(1, 4).kr(2, gate: 1)
					* 0.3).dup;
			}.play(outbus: spat.outbus);
		)

  }


	danger {
		"TsabikaSouflia: DANGER".postln;
		this.substitute(
			{
				(PlayBuf.ar(buffer.numChannels, buffer, 2.2, loop: 1)
					* SinOsc.ar(178) * SinOsc.ar(178.5) * SinOsc.ar(179)
					* SinOsc.ar(179.5) * SinOsc.ar(180)
					* Env.asr(0.01, 1, 0.5).kr(2, gate: 1) * 0.7).dup;
			}.play(outbus: spat.outbus);
		)
	}
}

