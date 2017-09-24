//
//  Synth.swift
//  
//
//  Created by Vincent Smithers on 9/17/17.
//

import Foundation
import AVFoundation
import AudioToolbox

public class Synth {
    
    ///The current sound that is playing
    public private(set) var playable: NotePlayable?
    
    public var effects = [Effect]() {
        didSet {
            check(status: AUGraphClearConnections(graph))
            
            var previousNode = mixerNode
            for effect in effects {
                var node = AUNode()
                
                var description = effect.description
                
                check(status: AUGraphAddNode(graph, &description, &node))
                
                var unit: AudioUnit?
                
                check(status: AUGraphNodeInfo(graph, node, nil, &unit))
                
                effect.setParameters(unit: &unit!)
                
                check(status: AUGraphConnectNodeInput(graph, previousNode, 0, node, 0))
                
                previousNode = node
            }
            
            check(status: AUGraphConnectNodeInput(graph, previousNode, 0, outputNode, 0))
            
            //Set render callbacks again
            for (index, sound) in sounds.enumerated() {
                let pointer = UnsafeMutablePointer<Sound>.allocate(capacity: 1)
                pointer.initialize(to: sound)
                
                var renderCallbackStruct = AURenderCallbackStruct(inputProc: sound.renderCallback, inputProcRefCon: pointer)
                
                check(status: AUGraphSetNodeInputCallback(graph, mixerNode, UInt32(index), &renderCallbackStruct))
            }
            
            check(status: AUGraphUpdate(graph, nil))
        }
    }
    
    public let sampleRate: Float
    
    public var envTime: UInt64 = 0
    //Used for transitioning from attack/decay -> release
    public var sustainedLevel: Float = 0
    
    public struct Envelope {
        public var attack, decay, sustain, release: Float
    }
    
    public var envelope = Envelope(attack: 0, decay: 0, sustain: 1, release: 0)
    
    public var freqMod: (Float) -> Float = { _ in 1 }
    public var freqModAmount: Float = 1
    
    public var isPlaying = false
    
    let outputUnit, mixerUnit: AudioUnit
    var outputNode = AUNode(), mixerNode = AUNode()
    let graph: AUGraph
    
    public let sounds: [Sound]
    
    public init(sounds: [Sound], sampleRate: Float = 44100) {
        self.sounds = sounds
        self.sampleRate = sampleRate
        
        var newGraph: AUGraph?
        check(status: NewAUGraph(&newGraph))
        
        graph = newGraph!
        
        var outputDescription = AudioComponentDescription(componentType: kAudioUnitType_Output,
                                                          componentSubType: OSType(kAudioUnitSubType_RemoteIO),
                                                          componentManufacturer: kAudioUnitManufacturer_Apple,
                                                          componentFlags: 0, componentFlagsMask: 0)
        
        check(status: AUGraphAddNode(graph, &outputDescription, &outputNode))
        
        var mixerDesc = AudioComponentDescription(componentType: kAudioUnitType_Mixer,
                                                  componentSubType: kAudioUnitSubType_MultiChannelMixer,
                                                  componentManufacturer: kAudioUnitManufacturer_Apple,
                                                  componentFlags: 0,
                                                  componentFlagsMask: 0)
        
        check(status: AUGraphAddNode(graph, &mixerDesc, &mixerNode))
        
        check(status: AUGraphConnectNodeInput(graph, mixerNode, 0, outputNode, 0))
        
        check(status: AUGraphOpen(graph))
        
        var newOutputUnit: AudioUnit?
        check(status: AUGraphNodeInfo(graph, outputNode, nil, &newOutputUnit))
        
        var newMixerUnit: AudioUnit?
        check(status: AUGraphNodeInfo(graph, mixerNode, nil, &newMixerUnit))
        
        
        self.outputUnit = newOutputUnit!
        self.mixerUnit = newMixerUnit!
        
        //Assign sounds synths
        sounds.forEach { $0.synth = self }
        
        //Set sounds for the mixer
        
        var numberOfBuses = UInt32(sounds.count)
        check(status: AudioUnitSetProperty(mixerUnit,
                                           kAudioUnitProperty_ElementCount,
                                           kAudioUnitScope_Input,
                                           0,
                                           &numberOfBuses,
                                           UInt32(MemoryLayout<UInt32>.size)))
        
        //Set render callbacks
        for (index, sound) in sounds.enumerated() {
            let pointer = UnsafeMutablePointer<Sound>.allocate(capacity: 1)
            pointer.initialize(to: sound)
            
            var renderCallbackStruct = AURenderCallbackStruct(inputProc: sound.renderCallback, inputProcRefCon: pointer)
            
            check(status: AUGraphSetNodeInputCallback(graph, mixerNode, UInt32(index), &renderCallbackStruct))
            
            //Set volumes while we're at it
            check(status: AudioUnitSetParameter(mixerUnit, kMultiChannelMixerParam_Volume, kAudioUnitScope_Input, UInt32(index), sound.volume * 0.5, 0))
        }
        
        check(status: AudioUnitSetParameter(mixerUnit, kMultiChannelMixerParam_Volume, kAudioUnitScope_Output, 0, 0.5, 0))
        
        
        //Set stream quality and stuff
        var streamDescription = AudioStreamBasicDescription()
        streamDescription.mSampleRate = Double(self.sampleRate)
        streamDescription.mFormatID = kAudioFormatLinearPCM
        streamDescription.mFormatFlags = kAudioFormatFlagsNativeFloatPacked | kAudioFormatFlagIsNonInterleaved
        streamDescription.mFramesPerPacket = 1
        streamDescription.mChannelsPerFrame = 2
        streamDescription.mBitsPerChannel = UInt32(MemoryLayout<Float32>.size * 8)
        streamDescription.mBytesPerFrame = UInt32(MemoryLayout<Float32>.size)
        streamDescription.mBytesPerPacket = UInt32(MemoryLayout<Float32>.size)
        
        check(status: AudioUnitSetProperty(mixerUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Input, 0, &streamDescription, UInt32(MemoryLayout<AudioStreamBasicDescription>.size)))
        check(status: AudioUnitSetProperty(mixerUnit, kAudioUnitProperty_StreamFormat, kAudioUnitScope_Output, 0, &streamDescription, UInt32(MemoryLayout<AudioStreamBasicDescription>.size)))
        
        check(status: AUGraphInitialize(graph))
        
        check(status: AUGraphStart(graph));
        
        //Use this for debugging
        //        CAShow(UnsafeMutablePointer<AUGraph>(graph))
    }
    
    /// Begins playing the specified item
    public func play(_ playable: NotePlayable) {
        self.playable = playable
        isPlaying = true
        envTime = mach_absolute_time()
    }
    
    /// Releases the currently played item
    public func release() {
        isPlaying = false
        envTime = mach_absolute_time()
    }
    
    /// Stops the synthesizer
    public func stop() {
        AUGraphStop(graph)
    }
    
    /// Starts the synthesizer
    public func start() {
        AUGraphStart(graph)
    }
    
}

func check(status: OSStatus) {
    if status != noErr {
        print("error occured with code \(status)")
    }
}
