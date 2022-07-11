//
// Created by PremierSoft on 11/07/22.
//

import Foundation

class MockTonePlayer: TonePlayer {
    func playStartTone() {
        delay(millis: 100)
        print("Playing Start Tone!")
    }

    func playEndTone() {
        delay(millis: 100)
        print("Playing End Tone!")
    }

    func playErrorTone() {
        delay(millis: 100)
        print("Playing Error Tone!")
    }
}