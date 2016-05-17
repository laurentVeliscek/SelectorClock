# SelectorClock
As AudioKit AKOperations can't trigger arbitrary code, I made 2 classes to solve the problem using AKSequencer.


SelectorMidiInstrument.swift is a dummy AKMidiInstrument that trig functions each time it recaive a NoteOn

SelectorClock.swift instanciates a SelectorMidiInstrument slaved by a sequencer.

So you can very easily hook any function to be triggered at regular intervals.


