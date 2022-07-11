//
// Created by PremierSoft on 11/07/22.
//

import Foundation

class MockSignalingService: SignalingService {
    var mockReturn = true
    var requestToTalkShouldThrowError = false
    var informEndOfSpeechThrowError = false

    func requestToTalk() throws -> Bool {
        delay(millis: 300)
        if requestToTalkShouldThrowError {
            throw NSError(domain: "Random REQUEST TO TALK Signaling error", code: 123)
        }
        print("Signaling service returns: \(mockReturn)")
        return mockReturn
    }

    func informEndOfSpeech() throws {
        delay(millis: 300)
        if informEndOfSpeechThrowError {
            throw NSError(domain: "Random END OF SPEECH Signaling error", code: 123)
        }
    }
}