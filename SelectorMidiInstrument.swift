//
//  SelectorMidiInstrument.swift
//
//
//  Created by Laurent Veliscek on 17/05/2016.
//  Copyright © 2016 Laurent Veliscek. All rights reserved.
//

import Foundation
import AudioKit



/******************************************************************************************

 SelectorMidiInstrument is a dummy midiInstrument that will trig passed functions each time
 it receive Midi noteOn message.

 It can be easily tweaked to trig different functions from different NoteOn Messages.

 *******************************************************************************************/


class SelectorMidiInstrument: AKMIDIInstrument{

    // MARK: Private Properties
    private var _clients:Array<Void -> Void> = []
    private var _clickOsc = AKFMSynth(voiceCount: 2)
    private var _clickPlayed = false
    private var _tickNumber = 0



    // MARK: Public Properties

    var tickNumber: Int{
        get {
            return _tickNumber
        }
    }

    // default value is true
    // when set to false, a click note is produced
    var silent = true



    // Midi Pitch of the click note (should be from 10 to 110)
    var clickPitch = 60

    // Volume of the click note
    var clickVolume: Double {
        get{
            return _clickOsc.volume
        }
        set {
            if newValue < 0 {
                _clickOsc.volume = 0
            }
            else{
                _clickOsc.volume = newValue
            }
        }
    }

    func reset(){
        _tickNumber = 0
    }

    init() {
        super.init(instrument: _clickOsc)
        _clickOsc.attackDuration = 0.001
        _clickOsc.decayDuration = 0.01
        _clickOsc.sustainLevel = 0.001
        _clickOsc.releaseDuration=0.01
        _clickOsc.volume = 0.1
        print ("SelectorMidiInstrument initialized")
    }

    // add a function to be triggered each time a NoteOn is received
    func addClient(f: Void -> Void){
        _clients.append(f)
        print ("client added !")
    }

    // will trig any functions attached using addClient method
    private func trigClients()
    {
        _tickNumber += 1
        for c in _clients
        {
            c()
        }
    }


    // Will trig in response to any noteOn Message
    override internal func startNote(note: Int, withVelocity velocity: Int, onChannel channel: Int) {

        trigClients()

        if _clickOsc.volume > 0.0 &&  silent == false

        {
            if _clickPlayed
            {
                _clickOsc.stopNote(clickPitch)
            }
            else{

                _clickPlayed = true
            }

            _clickOsc.playNote(clickPitch, velocity: 100)
        }
    }

    override internal func stopNote(note: Int, onChannel channel: Int) {
        // Does nothing, this instrument is not supposed to respond to NoteOff messages
    }
}


