//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

class MockTransmissionService: TransmissionService {
    var subject = PassthroughSubject<TransmissionStatus, Never>()

    var shouldThrowStartError = false
    var shouldThrowStopError = false

    func start() throws {
        delay(millis: 200)
        if shouldThrowStartError {
            throw NSError(domain: "Random START Transmission error", code: 123)
        }
        print("Transmission started")
    }

    func stop() throws {
        delay(millis: 200)
        if shouldThrowStopError {
            throw NSError(domain: "Random STOP Transmission error", code: 123)
        }
        print("Transmission stopped")
    }
}