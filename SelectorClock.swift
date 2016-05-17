//
//  SelectorClock.swift
//
//  Created by Laurent Veliscek on 17/05/2016.
//  Copyright © 2016 Laurent Veliscek. All rights reserved.
//

import Foundation
import AudioKit



/******************************************************************************************

 SelectorClock is a wrapper for SelectorMidiInstrument.

 You have access to it's sequencer (SelectorClock.sequencer: AKsequencer) so you can add tracks,
 and use it like a master sequencer that will record/play midi events.

 If you use it as a master sequencer, functions will be triggered in perfect sync.

 *******************************************************************************************/



class SelectorClock{

    let midi = AKMIDI()
    private var seq = AKSequencer()
    private var clicker:SelectorMidiInstrument?
    private var bpm:Double

    var output:AKNode?

    init(tempo: Double = 120, division: Int = 4)
    {
        bpm = tempo
        clicker = SelectorMidiInstrument()
        output = clicker


        clicker?.enableMIDI(midi.midiClient, name: "clicker midi in")
        clicker?.clickPitch = 60
        clicker?.clickVolume = 0.1

        // We build the track that will act as a metronome
        let clickTrack = seq.newTrack()
        for i in 0 ..< (division)  {
            clickTrack?.addNote(60, velocity: 100, position: Double(i ) / Double(division) , duration: Double(1.0 / Double(division)))
        }

        // Our clickTrack is targeted to our clicker instrument
        clickTrack?.setMIDIOutput((clicker?.midiIn)!)
        clickTrack?.setLoopInfo(1.0, numberOfLoops: 0)
        seq.setBPM(bpm)
    }

    // Play from beginning
    func start()
    {
        seq.rewind()
        clicker?.reset()
        seq.play()
    }

    // Pause without rewind
    func pause()
    {
        seq.stop()
    }

    // Stop and rewind
    func stop()
    {
        seq.stop()
        seq.rewind()
        clicker?.reset()
    }

    // Continue without rewind
    func play()
    {
        seq.play()
    }

    // Here you hook any function to be triggered
    func addClient(f: Void -> Void){
        clicker?.addClient(f)
    }

    // Default is true
    var silent:Bool{
        get{
            return (clicker?.silent)!
        }
        set{
            clicker?.silent = newValue
        }
    }

    // Sets click volume when .silent is false
    var volume:Double{
        get{
            return (clicker?.clickVolume)!
        }
        set {
            clicker?.clickVolume = newValue

        }
    }
    // Midi Note Pitch of the click (from 20 to 120)
    var pitch:Int{
        get{
            return (clicker?.clickPitch)!
        }
        set {
            clicker?.clickPitch = newValue

        }
    }
    // Return the current Tick number ( = how many times we have triggered...)
    var currentTick: Int{
        get{
            return (clicker?.tickNumber)!
        }
    }

    // You can adjust Tempo in real time
    var tempo:Double{
        get{
            return self.bpm
        }
        set{
            seq.setBPM(newValue)
        }
    }


    // You can access the internal sequence freely to add tracks and events like any AKSequencer
    var sequence:AKSequencer{
        get{
            return seq
        }
    }



    
}