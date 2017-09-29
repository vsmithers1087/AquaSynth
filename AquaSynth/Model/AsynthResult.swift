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
        switch className {
        case "No Bowl":
            self.label = .noBowl
        case "Still":
            self.label = .still
        case "Disturbed":
            self.label = .disturbed
        default:
            self.label = .none
        }
        self.probability = probability
    }
}
