//Kostis Karagiannis TX2020038

Midis : Creature {

    dawn {
        this.substitute({
            |gate = 1|
            var body, soul, env, sig;
            body = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * 0.4, loop: 1);
            soul = SinOsc.ar(XLine.kr(100, 466, 10));
            env = EnvGen.kr(Env.asr(4, 0.4, 2), gate, doneAction: 2);
            sig = body * soul * env;
            sig.dup;
        }.play(outbus: synth.outbus));
    }

   day {
        this.substitute({
            |gate = 1|
            var body, soul, env, sig;
            body = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * 1.5, loop: 1);
            soul = SinOsc.ar(657);
            env = EnvGen.kr(Env.asr(0.5, 0.6, 1), gate, doneAction: 2);
            sig = body * soul * env;
            sig.dup;
        }.play(outbus: synth.outbus));
    }

    dusk {
        this.substitute({
            |gate = 1|
            var body, soul, env, sig;
            body = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * 0.8, loop: 1);
            soul = SinOsc.ar(250);
            env = EnvGen.kr(Env.asr(2, 0.4, 3), gate, doneAction: 2);
            sig = body * soul * env;
            sig.dup;
        }.play(outbus: synth.outbus));
    }

    night {
        this.substitute({
            |gate = 1|
            var body, soul, env, sig;
            body = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * 0.5, loop: 1);
            soul = SinOsc.ar(80);
            env = EnvGen.kr(Env.asr(5, 0.2, 5), gate, doneAction: 2);
            sig = body * soul * env;
            sig.dup;
        }.play(outbus: synth.outbus));
    }

    danger {
        this.substitute({
            |gate = 1|
            var body, soul, env, sig;
            body = PlayBuf.ar(1, buffer, BufRateScale.kr(buffer) * 2.0, loop: 1);
            soul = SinOsc.ar(LFNoise0.kr(10).range(400, 2000));
            env = EnvGen.kr(Env.asr(0.01, 0.8, 0.1), gate, doneAction: 2);
            sig = body * soul * env;
            sig.dup;
        }.play(outbus: synth.outbus));
    }
}
