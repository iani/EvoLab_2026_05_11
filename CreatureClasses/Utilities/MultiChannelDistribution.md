# Useful built-in templates/techniques:

## Core classes to study

`Bus`
For your 12 mono input buses and 4 output buses.

```supercollider
~inBuses = 12.collect { Bus.audio(s, 1) };
~outBus = Bus.audio(s, 4);
```

`Group`
Use separate groups so ordering is clear:

```supercollider
~sourceGroup = Group.head(s);
~mixerGroup  = Group.after(~sourceGroup);
```

Your synths write into `~inBuses`; mixer synths run after them.

`SynthDef`, `Synth`, `In`, `Out`, `PanAz`
This is the actual mixer-strip pattern:

```supercollider
SynthDef(\azStrip, { |inBus, outBus, pan = 0, amp = 1, width = 2|
	var sig, az;
	sig = In.ar(inBus, 1);
	az = PanAz.ar(4, sig, pan, amp, width);
	Out.ar(outBus, az);
}).add;
```

Then create 12 strip synths:

```supercollider
~strips = 12.collect { |i|
	Synth.after(~sourceGroup, \azStrip, [
		\inBus, ~inBuses[i],
		\outBus, ~outBus,
		\pan, i.linlin(0, 11, -1, 1),
		\amp, 1
	], target: ~mixerGroup)
};
```

## Built-in classes worth examining

`Volume`
Good model for a small control object that owns a synth and exposes `volume`, `mute`, `gui`.

`NdefMixer`
Very useful GUI/model pattern for managing many named audio processes.

`ProxyMixer`
Probably the closest built-in conceptual template for a custom live mixer GUI.

`NodeProxy` / `Ndef`
Useful if you want flexible, replaceable signal sources and live-coding style routing.

`Monitor`
Important class to inspect: it handles routing, level, play/stop, and bus monitoring for proxies.

`ServerMeter`
Useful if you want to learn how SC builds metering GUIs, though it is not a mixer.

## Optional external template

The `MixerChannel` quark is also worth studying. It provides a more DAW-like channel abstraction: buses, inserts, sends, levels, routing. Even if you do not use it directly, its design is relevant.

## Suggested architecture

```text
12 source synths
  each Out.ar to its own mono Bus

12 mixer strip synths
  each In.ar from one mono Bus
  each PanAz.ar(4, ...)
  each Out.ar to shared 4-channel output Bus

master synth
  In.ar 4 channels
  optional limiter / gain / mute
  Out.ar hardware outputs 0–3
```

The most directly relevant SCClassLibrary classes are therefore:

```supercollider
Bus
Group
SynthDef
Synth
In
Out
PanAz
Volume
NdefMixer
ProxyMixer
Monitor
```

For your case, I would start from `Bus + Group + SynthDef + Synth`, then study `Volume` and `ProxyMixer` for object/API/GUI design.


