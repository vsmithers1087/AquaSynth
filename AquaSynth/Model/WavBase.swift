//
//  WavBase.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 12/16/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import Foundation
import AudioKit

import Foundation
import AudioKit

public class WavBase {
    
    public var player: AKAudioPlayer!
    public var delay: AKDelay!
    public var reverb: AKReverb!
    
    public init(filename: String) {
        do {
            let file = try AKAudioFile(readFileName: filename)
            player = try AKAudioPlayer(file: file)
        } catch {
            AKLog("File Not Found")
            return
        }
        
        delay = AKDelay(player)
        
        delay.time = 0.4
        delay.feedback = 0.8
        
        let reverb = AKReverb(delay)
        reverb.dryWetMix = 0.9
        reverb.loadFactoryPreset(.largeRoom2)
        
        AudioKit.output = reverb
        AudioKit.start()
    }
}
