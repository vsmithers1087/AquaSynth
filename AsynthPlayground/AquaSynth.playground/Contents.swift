//: Playground - noun: a place where people can play

import UIKit
import AsynthPlayground
import PlaygroundSupport

//func mockSynthResult() -> [AsynthResult] {
//    var results = [AsynthResult]()
//    for number in 0...10 {
//        var label = AsynthResultLabel.none
//        switch number {
//        case 0, 3, 5, 7, 10:
//            label = AsynthResultLabel.noBowl
//        case 6,8,9:
//            label = AsynthResultLabel.disturbed
//        case 1,2,4:
//            label = AsynthResultLabel.still
//        default:
//            break
//        }
//        let probability = Double(number) * 0.1
//        let result = AsynthResult(className: label.rawValue, probability: probability)
//        results.append(result)
//    }
//    return results
//}
//
//let soundMap = ResonanceSoundMap(predictionsPerNote: 11, wave: triangle)
//let results = mockSynthResult()
//results.forEach { (label) in
//    //usleep(UInt32(10e6 * 0.1))
//    sleep(2)
//    print(label.label)
//    soundMap.playForResult(label)
//}

//PlaygroundPage.current.needsIndefiniteExecution = true

//let synth = Synth(sounds: [Sound(wave: triangle, volume: 1)], sampleRate: 8000)
//synth.envelope.attack = 0.6
//synth.envelope.decay = 1.0
//synth.envelope.release = 0.3
//synth.envelope.sustain = 0.5
//synth.play(400)

var melodySynth = Synth(sounds: [Sound(wave: sin, volume: 1)])

enum Beat: Int {
    case    semibreve = 1,
    minim = 2,
    crotchet = 4,
    halfTriplet = 6,
    quaver = 8,
    triplet = 12,
    semiquaver = 16,
    semidemiquaver = 32
}

struct Sequencer: Sequence, IteratorProtocol {
    typealias Element = NotePlayable
    
    let playables: [NotePlayable]
    let bpm: Double
    let beat: Beat
    init(playables: [NotePlayable], bpm: Double = 120, beat: Beat = .crotchet) {
        self.playables = playables
        self.bpm = bpm
        self.beat = beat
    }
    
    var i = 0
    mutating func next() -> NotePlayable? {
        //Wait between notes
        let beatLength = 4.0 / Double(beat.rawValue)
        usleep(UInt32(3.0e6 * (60.0 / bpm * beatLength)))
        
        let next = playables[i]
        i = (i + 1) % playables.count
        return next
    }
}

melodySynth.envelope.attack = 0.05
melodySynth.envelope.release = 0.1
melodySynth.envelope.sustain = 0.5
melodySynth.envelope.decay = 0.3

melodySynth.effects = [.distortion(decimation: 50, decimationMix: 20, ringModMix: 0, finalMix: 30)]


//Generate the arpeggio to Arpeggi/Weird Fishes by Radiohead
var weirdFishes = [Note]()
let triplets: [[Note]] = [[.A(4), .A(3), .A(2)],
                          [.A(3), .A(2), .A(1)],
                          [.A(2), .A(1), .A(0)],
                          [.A(1), .A(0)]]
for triplet in triplets {
    (0...10).forEach { _ in weirdFishes += triplet }
    weirdFishes.removeLast()
}


//A delay between playing and releasing the note
let hold: Double = 1 / 80

for note in Sequencer(playables: weirdFishes, bpm: 120, beat: .triplet) {
    melodySynth.play(note).A(1)
    usleep(UInt32(1.0e6 * (60.0 / 120.0 * hold)))
    melodySynth.release()
}


