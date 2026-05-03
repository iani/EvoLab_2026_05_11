//:
Tsk.play(\dawn, Pwhite(0.1, 0.4, inf), 100, [amp: Pwhite(0.01, 0.3, inf)]);
//: bubbles
Tsk.play(\night, Prand([1, 1, 2, 4]/25, inf), inf,
	[fmul: Pwhite(0.15, 4.0, inf)]);
//:
Tsk.play(\night, 0.1, inf, [fmul: Pwhite(0.15, 4.0, inf)]);
//:
Tsk.play(\night, 0.1, inf, [fmul: Pseries(0.15, 0.03, 200)]);
//:
Tsk.play(\night, Prand([1, 1, 2, 4]/25, inf), inf,
	[fmul: Pn(Pseries(0.15, 0.03, 200), inf)]);
Tsk.dawn;
Tsk.morning;

Tsk.play(Tsk.states.pyramid, [0.1, 0.1, 0.5, 0.25].pyramid, 16)

Tsk.pb(Prand(Tsk.states, inf), Pfunc({ 0.05.exprand(2) }));

//:
{
	Resonz.ar(
		GrayNoise.ar(Env.perc(0.01, 2).kr(0) * 0.1),
		Line.kr(Rand(50, 2000), Rand(50, 2000), 2.5) * SinOsc.kr(Line.kr(3, 10, 3)).abs,
		0.7
	).ds(time:0.5);
}.play;
//:

Tsk.day;
Tsk.noon;
Tsk.afternoon;
Tsk.evening;
Tsk.night;


//: need debugging
Tsk.play(\evening);

//
Tsk.play(\night);

Tsk.play(\night, 0.1, inf, [fmul: Pwhite(1.0, 2.0, inf)]);
Tsk.play(\night, 0.1, 1, [fmul: Pwhite(1.0, 2.0, inf)]);
Tsk.play(\night, extras: [fmul: 12]);
Tsk.play(\night, 0.1, 3)
Tsk.play([\day, \night], [0.1, 0.2, 0.1], 16)
//:
Tsk.pbindPlay(
	Pseq([\night], 1), 1
)


Tsk.play([\day, \night], 0.2, 16)
Tsk.play(Tsk.states, 0.2, 16)
Tsk.play(Tsk.states.pyramid, 0.2, 16)
Tsk.play(Tsk.states.pyramid, [0.1, 0.1, 0.5, 0.25].pyramid, 16)
Tsk.play(Tsk.states, 0.1, 16)
Tsk.states;
//:============================================================
//Parametrize state calls from a pattern
Tsk.states = [\parametric];
Tsk.controller;
Tsk.controller.put()
Tsk.states;
Tsk.play(\parametric);
Tsk.states = ()
Tsk.play(\night);

//============================================================ 
//: WhiteNoise studies
{
	WhiteNoise.ar()
}
//:
x = { MoogFF.ar(WhiteNoise.ar(01.1), MouseY.kr(100, 4000, 1), MouseX.kr(0, 4)) }.play(s);
//:
z = {
    BHiPass.ar(
        WhiteNoise.ar(0.1),
        MouseX.kr(10, 20000, \exponential), // cutoff freq.
        MouseY.kr(0.0, 1.0, \linear), // rq
        0.5); // mul
}.play