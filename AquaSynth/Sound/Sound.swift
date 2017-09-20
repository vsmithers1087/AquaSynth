//
//  Sound.swift
//  
//
//  Created by Vincent Smithers on 9/17/17.
//

import Foundation
import AVFoundation
import AudioToolbox

public class Sound {
    public var wave: (Float) -> Float
    public var volume: Float
    private var currentPhase: Float = 0
    internal var synth: Synthesizer?
    
    public init(wave: @escaping (Float) -> Float, volume: Float) {
        self.wave = wave
        self.volume = volume
    }
    
    let renderCallback: AURenderCallback = { inRefCon, actionFlags, timestamp, busNumber, frameCount, outputData in
        let buffers = UnsafeMutableAudioBufferListPointer(outputData!)
        
        var soundPointer = inRefCon.assumingMemoryBound(to: Sound.self)
        
        var sound = soundPointer.pointee
        
        guard var synth = sound.synth else {
            return noErr
        }
        
        let period: Float = synth.sampleRate / (synth.playable ?? Note.C(3)).freq
        
        let secondsPassed = Float(Double(timestamp.pointee.mHostTime - synth.envTime) / 10e8)
        
        for frame in 0..<frameCount {
            
            let freqMod = synth.freqMod(sound.currentPhase * synth.freqModAmount)
            
            let waveAmplitude = sound.wave((sound.currentPhase / period * freqMod) * 2 * .pi)
            
            let amplitude: Float
            
            if synth.isPlaying {
                if secondsPassed < synth.envelope.attack {
                    //Attack
                    let attackAmount = min(1, secondsPassed / synth.envelope.attack)
                    amplitude = waveAmplitude * attackAmount
                    synth.sustainedLevel = attackAmount
                } else {
                    let decayAmount = min(1, (secondsPassed - synth.envelope.attack) / synth.envelope.decay)
                    let lerp = 1 + (synth.envelope.sustain - 1) * decayAmount
                    
                    synth.sustainedLevel = lerp
                    //Decay
                    amplitude = waveAmplitude * lerp
                }
            } else {
                //Release
                amplitude = waveAmplitude * synth.sustainedLevel * (1 - min(1, secondsPassed / synth.envelope.release))
            }
            
            for buffer in buffers {
                guard let data = buffer.mData else { continue }
                UnsafeMutablePointer<Float32>(data.assumingMemoryBound(to: Float32.self))[Int(frame)] = Float32(amplitude)
            }
            
            sound.currentPhase = fmod(sound.currentPhase + 1, period)
        }
        
        return noErr
    }
}

