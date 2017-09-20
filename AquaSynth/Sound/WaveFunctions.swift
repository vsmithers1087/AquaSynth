//
//  Waves.swift
//  
//
//  Created by Vincent Smithers on 9/17/17.
//

import Foundation

public func square(phase: Float = 0.5) -> (Float) -> Float {
    return { t in
        t > 2 * .pi * phase ? 1 : 0
    }
}

public func saw(_ t: Float) -> Float {
    return t - floor(t / (2 * .pi))
}

public func triangle(_ t: Float) -> Float {
    let a = t - floor(t + 0.5)
    let b = pow(-1.0, floor(t + 0.5))
    return 2 * a * b
}
