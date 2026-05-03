Talos : Creature {

    *fileName {
        ^"talos.wav";
    }

    dawn {

        this.substitute({

            var body, soul, ring, breath, saturated, reverbed;

            body = PlayBuf.ar(
                1,
                this.buffer,
                BufRateScale.kr(this.buffer) * 0.8,
                loop: 1
            );

            soul = SinOsc.ar(
                LFNoise2.kr(0.1).range(80, 140)
            );

            ring = body * soul;

            breath = LFTri.kr(0.15).range(0.1, 0.6);

            saturated = tanh(ring * breath * 1.2);

            reverbed = FreeVerb.ar(
                saturated,
                mix: 0.25,
                room: 0.8,
                damp: 0.4
            );

            reverbed ! 2

        }.play, 3);
 }
    day {

        this.substitute({

            var body, soul, ring, breath, saturated, reverbed;

            body = PlayBuf.ar(
                1,
                this.buffer,
                BufRateScale.kr(this.buffer),
                loop: 1
            );

            soul = SinOsc.ar(
                LFNoise2.kr(0.2).range(50, 150)
            );

            ring = body * soul;

            breath = LFTri.kr(0.25).range(0.2, 0.9);

            saturated = tanh(ring * breath * 2.5);

            reverbed = FreeVerb.ar(
                saturated,
                mix: 0.5,
                room: 2,
                damp: 0.4
            );

            reverbed ! 2

        }.play, 1.5);

    }

    dusk {

        this.substitute({

            var body, soul, ring, breath, saturated, reverbed;

            body = PlayBuf.ar(
                1,
                this.buffer,
                BufRateScale.kr(this.buffer) * 0.6,
                loop: 1
            );

            soul = SinOsc.ar(
                LFNoise2.kr(0.08).range(60, 100)
            );

            ring = body * soul;

            breath = LFTri.kr(0.1).range(0.05, 0.4);

            saturated = tanh(ring * breath * 1.2);

            reverbed = FreeVerb.ar(
                saturated,
                mix: 0.35,
                room: 1.2,
                damp: 0.5
            );

            reverbed ! 2

        }.play, 4);

    }

    night {

        this.substitute({

            var body, soul, ring, breath;

            body = PlayBuf.ar(
                1,
                this.buffer,
                BufRateScale.kr(this.buffer) * 0.5,
                loop: 1
            );

            soul = SinOsc.ar(55);

            ring = body * soul;

            breath = LFTri.kr(0.03).range(0.02, 0.15);

            (ring * breath * 0.3) ! 2

        }.play, 4);

    }

	 danger {

        this.substituteTimed({

            var body, soul, ring, pulse, distorted, scream;

            body = PlayBuf.ar(
                1,
                this.buffer,
                BufRateScale.kr(this.buffer) * 1.2,
                loop: 1
            );

            soul = SinOsc.ar(
                LFNoise1.kr(6).range(80, 400)
            );

            ring = body * soul;

            pulse = LFPulse.kr(
                LFNoise1.kr(0.5).range(3, 8),
                0,
                0.5
            );

            distorted = tanh(ring * pulse * 4);

            scream = FreeVerb.ar(
                distorted,
                mix: 0.6,
                room: 1.5,
                damp: 0.2
            );

            scream ! 2

        }.play, 3.5, 0.5);

    }
  }
