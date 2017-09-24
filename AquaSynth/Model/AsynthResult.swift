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

public typealias AsynthResult = (label: AsynthResultLabel, probability: Double)
