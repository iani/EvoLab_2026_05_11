// extend Event so that it can play event chains using the same mechanism
// as implemented in class Chain.
// Tests here
~phrases = (
	snare: Pn(\tsk, 10)
);
(
tsk: {
	{ PinkNoise.ar(Env.perc.kr(2)).dup / 10 }.play;
	0.05
},
ping: {
	{ SinOsc.ar(Rand(400, 1000), 9, Env.perc.kr(2)).dup / 10 }.play;
	0.17
}).chain(Pseq([\ping, \tsk, \ping, ~phrases.snare, \ping], 2));

//: .chain(Pseq([\tsk, Pn(\ping, 4)], 3));

//:
(1..10)[1..]
nil.asArray[1..];