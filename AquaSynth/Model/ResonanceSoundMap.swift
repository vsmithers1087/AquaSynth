//
//  ResonanceSoundMap.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit

public class ResonanceSoundMap {
    
    public var predictionsPerNote: Int
    public var wave: (Float) -> Float
    private var synth: Synth
    private var asynthResults = [AsynthResult]()
    private var frequencies = [Int]()
    private var isRunning = false
    
    public init(predictionsPerNote: Int, wave: @escaping (Float) -> Float) {
        self.predictionsPerNote = predictionsPerNote
        self.wave = wave
        self.synth = Synth(sounds: [Sound(wave: wave, volume: 1)], sampleRate: 44100)
    }
    
    public func addResult(_ result: AsynthResult) -> String {
        asynthResults.append(result)
        var returnVal: String?
        if asynthResults.count % predictionsPerNote == 0 {
            returnVal = mapResultsToSound()
            asynthResults.removeAll()
        }
        return returnVal ?? result.label.rawValue
    }
    
    public func mapResultsToSound() -> String {
        var frequency = 0
        for (label, score) in asynthResults {
            switch label {
            case AsynthResultLabel.still:
                let freqMod = 100 * score
                frequency += Int(freqMod)
            case AsynthResultLabel.disturbed:
                let freqMod = 200 * score
                frequency += Int(freqMod)
            case AsynthResultLabel.noBowl:
                let freqMod = 10 * score
                frequency += Int(freqMod)
            case .none:break
            }
        }
        
        //synth.freqMod = triangle
        //synth.freqModAmount = 0.5
        synth.play(frequency)
        return "Frequency: \(frequency) Hertz"
        //sleep(1)
        //synth.stop()
        // if all no bowl
        // if all still
        // if all disturbed
        // switch on number of labels for no bowl
        // switch on number of labels for still
        // switch on number of labels for disturbed
        
        //Hard Coded Patterns?
            //probability taken into account
    }
    
    public func soundForSessionStart() {}
 
    func stopSession() {
        asynthResults.removeAll()
        isRunning = false
    }
    
}
