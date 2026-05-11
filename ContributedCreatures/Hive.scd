Hive : Creature {

    *fileName {
        ^"hive.wav";
    }

    dawn {
        this.substitute({

            var body, soul, ring, breath;

            body = PlayBuf.ar(1, this.buffer, BufRateScale.kr(this.buffer) * 0.8, loop: 1);

            soul = SinOsc.ar(LFNoise2.kr(0.1).range(90, 140));

            ring = body * soul;

            breath = LFTri.kr(0.12).range(0.1, 0.6);

            FreeVerb.ar(ring * breath * 0.4, 0.25, 0.9, 0.4) ! 2

        }.play(outbus: spat.outbus), 3);
    }

    day {
        this.substitute({

            var body, soul, ring, breath, buzz;

            body = PlayBuf.ar(1, this.buffer, BufRateScale.kr(this.buffer), loop: 1);

            soul = SinOsc.ar(LFNoise2.kr(0.3).range(120, 220));

            ring = body * soul;

            breath = LFTri.kr(0.3).range(0.3, 1.0);

            buzz = tanh(ring * breath * 3);

            FreeVerb.ar(buzz, 0.45, 1.8, 0.3) ! 2

        }.play(outbus: spat.outbus), 1.5);
    }

    dusk {
        this.substitute({

            var body, soul, ring, breath;

            body = PlayBuf.ar(1, this.buffer, BufRateScale.kr(this.buffer) * 0.6, loop: 1);

            soul = SinOsc.ar(LFNoise2.kr(0.08).range(80, 120));

            ring = body * soul;

            breath = LFTri.kr(0.1).range(0.05, 0.4);

            FreeVerb.ar(ring * breath * 0.35, 0.35, 1.2, 0.5) ! 2

        }.play(outbus: spat.outbus), 4);
    }

    night {
        this.substitute({

            var body, soul, ring, breath;

            body = PlayBuf.ar(1, this.buffer, BufRateScale.kr(this.buffer) * 0.5, loop: 1);

            soul = SinOsc.ar(70);

            ring = body * soul;

            breath = LFTri.kr(0.03).range(0.02, 0.15);

            ring * breath * 0.25 ! 2

        }.play(outbus: spat.outbus), 4);
    }

    danger {

        this.substituteTimed({

            var body, soul, ring, pulse, swarm, distorted;

            body = PlayBuf.ar(
                1,
                this.buffer,
                BufRateScale.kr(this.buffer) * 1.5,
                loop: 1
            );

            soul = SinOsc.ar(
                LFNoise1.kr(8).range(300, 900)
            );

            ring = body * soul;

            pulse = LFPulse.kr(
                LFNoise1.kr(1).range(8, 16),
                0,
                0.4
            );

            swarm = ring * pulse;

            distorted = tanh(swarm * 8);

            distorted ! 2

        }.play(outbus: spat.outbus), 3.5, 0.2);

    }

}


