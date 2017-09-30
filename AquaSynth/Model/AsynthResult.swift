//
//  AsynthResult.swift
//  AquaSynth
//
//  Created by Vincent Smithers on 9/23/17.
//  Copyright © 2017 Vincent Smithers. All rights reserved.
//

import Foundation

public enum AsynthResultLabel: String {
    case noBowl = "No Bowl"
    case still = "Still"
    case disturbed = "Disturbed"
    case none = "N/A"
}


public struct AsynthResult {
    
    public var label: AsynthResultLabel
    public var probability: Double
    
    public init(className: String, probability: Double) {
        print(className)
        switch className {
        case "xA":
            self.label = .noBowl
        case "still":
            self.label = .still
        case "disturbedA":
            self.label = .disturbed
        default:
            self.label = .none
        }
        self.probability = probability
    }
}
