//
//  ResonanceSoundMap.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import UIKit
import AudioKit

class ResonanceSoundMap {
    
    var currentPeak: CGFloat = 0
    var currentNoteNumber: UInt8 = 0

    private var delay: AKDelay
    private var reverb: AKReverb
    private var mixer: AKMixer
    private let bells = AKTubularBells()
    private let cricket = WavBase(filename: "cricket.wav")
    private let leftOscillator = AKOscillatorBank(waveform: AKTable(.sine), attackDuration: 0.1, releaseDuration: 0.1)
    private let rightOscillator = AKOscillatorBank(waveform: AKTable(.sine), attackDuration: 0.1, releaseDuration: 0.1)
    
    init() {
        mixer = AKMixer(bells, cricket.player, leftOscillator, rightOscillator)
        delay = AKDelay(mixer)
        reverb = AKReverb(delay)
        AudioKit.output = reverb
        AudioKit.start()
    }
    
    func playForFrequency(_ prediction: Double, level: AsynthResultLabel) {
        var triggerFreq: Double = 0
        switch level {
        case .noBowl:
            delay.time = 0
            reverb.dryWetMix = 0
            cricket.player.play()
            leftOscillator.stop(noteNumber: currentNoteNumber)
            rightOscillator.stop(noteNumber: currentNoteNumber)
            currentNoteNumber = UInt8(triggerFreq)
            triggerFreq = 0
        case .still:
            triggerFreq = prediction / 1000.0
            delay.time = 0
            reverb.dryWetMix = 0
            leftOscillator.pitchBend = triggerFreq
            rightOscillator.pitchBend = triggerFreq
            var newNoteNumber: CGFloat = 59.0
            if newNoteNumber < currentPeak {
                currentPeak -= 3
                newNoteNumber = currentPeak
            }
            leftOscillator.play(noteNumber: UInt8(newNoteNumber - 1), velocity: 80)
            rightOscillator.play(noteNumber: UInt8(newNoteNumber), velocity: 80)
            currentNoteNumber = UInt8(newNoteNumber)
        case .disturbed:
            triggerFreq = (70 + prediction / 5) / 10
            delay.time = 3
            reverb.dryWetMix = 0.9
            leftOscillator.pitchBend = triggerFreq
            rightOscillator.pitchBend = triggerFreq
            bells.trigger(frequency: UInt8(93).midiNoteToFrequency())
            leftOscillator.play(noteNumber: 65, velocity: 80)
            rightOscillator.play(noteNumber: 66, velocity: 80)
            currentPeak = 66
            currentNoteNumber = UInt8(triggerFreq)
        default:
            break
        }
    }
}
