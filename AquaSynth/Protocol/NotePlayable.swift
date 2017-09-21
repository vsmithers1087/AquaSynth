//
//  SoundPlayable.swift
//  
//
//  Created by Vincent Smithers on 9/17/17.
//

import Foundation

public protocol NotePlayable {
    var freq: Float { get }
}

extension Float: NotePlayable {
    public var freq: Float {
        return self
    }
}

extension Double: NotePlayable {
    public var freq: Float {
        return Float(self)
    }
}

extension Int: NotePlayable {
    public var freq: Float {
        return Float(self)
    }
}


