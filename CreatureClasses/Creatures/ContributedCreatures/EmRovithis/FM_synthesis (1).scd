/* =======================================================================
CHAPTER: FM (FREQUENCY MODULATION)
σημειώσεις 22/12/25
*/


// simple FM
{ (SinOsc.ar(220 + SinOsc.ar(4, mul: 100)) * 0.2).dup}.play;
// if modulator mul = 1, then with FM carrier frequency range = 219-221
// if modulator mul = 100, then with FM carrier frequency range = 120-320
// if modulator mul = 10 and carrier freq = 230, then with FM carrier frequency range = 220-240

{ (SinOsc.ar(220 + SinOsc.ar(4, mul: 100)) * 0.2).dup}.play;
// similar to:
{ (SinOsc.ar(SinOsc.ar(4, mul: 100, add: 220)) * 0.2).dup}.play;
// similar to:
{ SinOsc.ar(freq: SinOsc.ar(freq: 4, mul: 100, add: 220), mul: 0.2).dup}.play;
// similar to:
{ (SinOsc.ar(SinOsc.ar(4) * 100 + 220) * 0.2).dup}.play;
// similar to:
0.2.dup;

(
{
	var carrier, modulator;
	modulator = SinOsc.ar(4, mul: 100);
	carrier = SinOsc.ar(220 + modulator, mul: 0.2).dup;
	}.play;
)

// control modulation rate & modulation range with mouse
{ SinOsc.ar(200 + SinOsc.ar(MouseX.kr(4, 100), mul: (MouseY.kr(10, 100)))) * 0.2.dup}.play;
