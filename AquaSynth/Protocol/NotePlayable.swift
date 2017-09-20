//
//  SoundPlayable.swift
//  
//
//  Created by Vincent Smithers on 9/17/17.
//

import Foundation

public protocol NotePlayable {
    /// freq
    /// Returns the frequency of the playable item
    var freq: Float { get }
}

extension Float: Playable {
    public var freq: Float {
        return self
    }
}

extension Double: Playable {
    public var freq: Float {
        return Float(self)
    }
}

extension Int: Playable {
    public var freq: Float {
        return Float(self)
    }
}


