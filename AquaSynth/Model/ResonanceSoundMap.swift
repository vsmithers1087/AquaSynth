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
    var mixer: AKMixer

    private var delay: AKDelay
    private var reverb: AKReverb
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
        stopOscilators(forNote: currentNoteNumber)
        switch level {
        case .noBowl:
            delay.time = 0
            reverb.dryWetMix = 0
            cricket.player.play()
        case .still:
            delay.time = 0.3
            reverb.dryWetMix = 0
            leftOscillator.pitchBend = prediction
            rightOscillator.pitchBend = prediction
            var newNoteNumber: CGFloat = 58.0
            if newNoteNumber < currentPeak {
                currentPeak -= 1
                newNoteNumber = currentPeak
            }
            leftOscillator.play(noteNumber: UInt8(newNoteNumber - 1), velocity: 80)
            rightOscillator.play(noteNumber: UInt8(newNoteNumber), velocity: 80)
            currentNoteNumber = UInt8(newNoteNumber)
        case .disturbed:
            delay.time = 0.4
            reverb.dryWetMix = 0.1
            leftOscillator.pitchBend = prediction + 0.33
            rightOscillator.pitchBend = prediction + 0.33
            bells.trigger(frequency: UInt8(111).midiNoteToFrequency())
            leftOscillator.play(noteNumber: 63, velocity: 80)
            rightOscillator.play(noteNumber: 64, velocity: 80)
            currentPeak = 64
            currentNoteNumber = UInt8(64)
        default:
            break
        }
    }
    
    private func stopOscilators(forNote note: UInt8) {
        guard note > 2 else { return }
        leftOscillator.stop(noteNumber: UInt8(currentNoteNumber - 1))
        rightOscillator.stop(noteNumber: UInt8(currentNoteNumber))
    }
}
