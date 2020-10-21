// Engine_16Sines
// 16 mono sinewaves

// Inherit methods from CroneEngine
Engine_16Klangs : CroneEngine {
	// Define a getter for the synth variable
	var <synth;

	// Define a class method when an object is created
	*new { arg context, doneCallback;
	// Return the object from the superclass (CroneEngine) .new method
	^super.new(context, doneCallback);
}
// Rather than defining a SynthDef, use a shorthand to allocate a function and send it to the engine to play
// Defined as an empty method in CroneEngine
// https://github.com/monome/norns/blob/master/sc/core/CroneEngine.sc#L31
alloc {
	// Define the synth variable, which is a function
	synth = {
		// define arguments to the function
		arg out, 
		freqs = [55, 110, 220, 440, 880, 1760, 3520, 7040, 14080, 55, 110, 220, 440, 880, 1760, 3520],
		amps = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		phases = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
		// Klangs (freq, phase, amplitude)
		var osc1 = DynKlang.ar(`[freqs, amps, phases])
    ];
		// Create an output object with a mix the klang output
		Out.ar(out, (osc1).dup);
	}.play(args: [\out, context.out_b], target: context.xg);

	// Export argument symbols as modulatable paramaters
	this.addCommand("freqs", "f", { arg msg;
		synth.set(\freqs, msg[1]);
	});

	this.addCommand("amps", "f", { arg msg;
		synth.set(\amps, msg[1]);
	});

	this.addCommand("phases", "f", { arg msg;
		synth.set(\phases, msg[1]);
	});

}
// define a function that is called when the synth is shut down
free {
	synth.free;
}
}
