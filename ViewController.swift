//
//  ViewController.swift
//
//  Created by Laurent Veliscek on 04/05/2016.
//  Copyright © 2016 Laurent Veliscek. All rights reserved.
//

import UIKit
import AudioKit



class ViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()


        // Let's instanciate a clock
        // at Tempo 120, that will trig every sixteenth note
        var myClock = SelectorClock(tempo: 120, division: 16)


        // We define a function to be triggered
        func aFunction(){
            print ("myClock -> tick!! \(myClock.currentTick) at  \(myClock.sequence.currentTime)")

        }

        // We attach this function to the clock
        myClock.addClient(aFunction)

        // For debug purpose, we'll make our clock make some noise
        myClock.silent = false

        // We can adjust the click pitch
        myClock.pitch = 80

        // and the click volume
        myClock.volume = 0.1

        // We must link the clock's output to AudioKit (even if we don't need the sound)
        AudioKit.output = myClock.output

        AudioKit.start()

        // Then We can start the clock !
        myClock.start()

        // Et voila!...  :-)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

