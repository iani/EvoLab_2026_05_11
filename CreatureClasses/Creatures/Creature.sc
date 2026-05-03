/*
This superclass provides the makeSynth and the loadBuffer method.
All creature classes should be created as subclasses of this class. Like this:

Frog : Creature {
	...
}

TODO:
	1. Integrate spatialization through spatialization instance var
	2. in state method code: add spatialization parameters: Panning!

*/

Creature {
	classvar <buffers; // Event with all buffers
	classvar defaults; // default Creature instances for easy testing
	classvar <>defaultBuffer;
	classvar <>defaultFileName = "cricket.wav";

	var <>buffer, <>actions, <spatialization;

	*asInstance { ^this.default }
	asInstance { ^this }
	// easy testing of instance methods dawn, day, etc.
	*doesNotUnderstand { | selector ... args |
		^this.default.perform(selector, *args);
	}

	*default {
		^this.defaults.at(this.name);
	}

	*defaults { // lazily create defaults
		defaults !? { ^defaults };
		defaults = (Creature: Creature.new);
		Creature.allSubclasses do: { | c |
			defaults.put(c.name, c.new)
		};
		defaults.put(this.name, this.new);
		^defaults;
	}

	// overwrite Object/Class release to enable custom Creature release:
	*release { | dur = 0.03 |this.default.release(dur); }
	// ------------------	
	*initClass {
		Class.initClassTree(ServerBoot);
		ServerBoot add: {
			{
				this.addSynthDefs;
				this.allSubclasses do: { | c |
					// c.postln;
					// "adding synthdef for above class".postln;
					c.addSynthDefs
				};
				Server.default.sync;
				this.loadBuffers;
				Server.default.sync;
			}.fork(AppClock)
		};
	}

	*loadBuffers {
		buffers = ();
		{
			this.loadDefaultBuffer;
			this.allSubclasses do: _.loadBuffer;
			Server.default.sync;
		}.fork(AppClock);
	}

	*loadDefaultBuffer {
		var defaultPath;
		defaultPath = this.audioFilesFolder +/+ defaultFileName;
		// postln("Loading default buffer from:\n" + defaultPath);
		defaultBuffer = Buffer.read(Server.default, defaultPath);
	}

	*new {
		^super.new.init;
	}

	init {
		buffer = buffers[this.class.name];
		actions = this.defaultActions;
		this.addCustomActions; // customizeable method for subclasses
	}

	// -------------------------------------------------
	performAction { | ... argState |
		var message, args;
		#message, args = argState;
		if (this respondsTo: message) {
			^this.perform(message, *args)
		}{
			currentEnvironment[~this = this];
			^actions[message].value(*args);
		}
	}
	// edit this function to add your own actions to your class.
	addCustomActions {
		this addActions: (
			test: {
				// this is the sound of the action
				{ PinkNoise.ar(Env.perc(0.01, 0.1).kr(2)).dup / 10 }.play;
				0.2; // this is the duration of the action
			} // add more actions after this as you like
		)
	}

	defaultActions {
		^(
			ping: {
				{ SinOsc.ar(400.rrand(4000), 0,
					Env.perc(0.01, 0.1).kr(2)).dup / 10
				}.play;
				0.1;
			},
			tsk: {
				{ WhiteNoise.ar(Env.perc(0.01, 0.1).kr(2)).dup / 10 }.play;
				0.1;
			}
		)
	}

	addActions { | argActions |
		argActions keysValuesDo: { | key, value | actions[key] = value; }
	}

	*addSynthDefs {
		// subclasses can add their own synthdefs here
	}
	//============================================================ 
	//        ------------- Buffer loading --------------
	//============================================================ 
	*loadBuffer {
		var thePath;
		// postln("Loading buffer for" + this.name);
		thePath = this.bufferPath;
		// "Buffer path is:".postln;
		// thePath.postln;
		if (File exists: thePath) {
			buffers[this.name] = Buffer.read(Server.default, thePath);
		}{
			// postln("Audiofile path not found:\n" + thePath);
			// "Using default buffer instead".postln;
			buffers[this.name] = defaultBuffer;
		}
	}

	*bufferPath {
		^this.audioFilesFolder +/+ this.fileName;
	}

	*audioFilesFolder { ^CreatureAudioFilesPath.path }
	*fileName {
		// subclasses can overrride here the name of the audio file to be loaded
		^this.name.asString.toLower ++ ".wav";
	}

	bufferPlay { ^this.buffer.play } // utility: play buffer, return synth

	//============================================================ 
	//   ------------- sound process interface -----------
	//============================================================ 

	// set argument/control values of synth
	set { | ... args |
		this.changed(\set, args);
	}

	// substitute all previous processes with this one
	// play this one for dur seconds
	substituteTimed {  | process, dur, releaseTime |
		this.release;
		{ this.addTimed(process, dur, releaseTime); }.defer;
		^process;
	}
	
	// release previous and add new synth or task
	substitute { | process, releaseTime |
		this release: releaseTime;
		this add: process;
		^process;
	}

	// release all added processes
	release { | releaseTime = 0.05 | 
		this.changed(\release, releaseTime);
	}

	// start tracking process for set, release.
	add { | process |
		^process addModel: this;
	}

	addTask { | func |
		^this add: Task(func).play;
	}

	addLoop { | func |
		^this add: Task({ func.loop }).play;
	}

	// add process, and stop it after dur seconds.
	addTimed { | process, dur = 1, releaseTime = 0.05 |
		var controller;
		controller = this add: process;
		{
			if (process.isPlaying) {
				process stopProcess: releaseTime;
			};
			controller.remove;
		} defer: dur;
		^process;
	}

	atplay { | actionsTimes |
		^this.play(*(actionsTimes.flat.clump(2).flop collect: _.asPattern))
	}

	*play { | argActions, durations = 5, repeats = 1, extras |
		^this.default.play(argActions, durations, repeats, extras);
	}
	play { | argActions, durations = 5, repeats = 1, extras |
		^this.pbindPlay(
			Pn(argActions.asPattern, repeats),
			Pn(durations.asPattern, inf),
			*extras
		)
	}

	// shortcut:
	pb { | actionsPattern, timesPattern ... pbindPairs |
		^this.pbindPlay(actionsPattern, timesPattern, *pbindPairs)
	}

	pbindPlay { | actionsPattern, timesPattern ... pbindPairs |
		if (pbindPairs.size < 2) { pbindPairs = [] };
		pbindPairs = [
			\action, actionsPattern.asPattern,
			\dur, timesPattern.asArray.flat.asPattern,
			\play, {
				var action, args;
				#action, args = ~action.asArray; 
				~action.postln;
				actions[action].(*args);
			}
		] ++ pbindPairs;
		^Pbind(*pbindPairs).play;
	}

	chain { | actionsPattern ... pbindPairs |
		if (pbindPairs.size < 2) { pbindPairs = [] };
		pbindPairs = [
			\action, actionsPattern.asPattern,
			\play, {
				var action, args;
				#action, args = ~action.asArray; 
				~action.postln;
				~dur = actions[action].(*args);
			}
		] ++ pbindPairs;
		^Pbind(*pbindPairs).play;
	}

	//------------------------------------------------------------
	/*
	addModel { | model |
		var controller;
		controller = SimpleController(model);
		actions do: { | s |
			controller.put(s, { | model, change ... args |
				this.perform(s, *args);
			});
		};
		^controller;
	}
	*/
}