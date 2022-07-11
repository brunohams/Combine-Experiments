//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import XCTest
import Combine

class TransmissionReducerTests: XCTestCase {
    var startTransmissionSpy: StartTransmissionSpy!
    var stopTransmissionSpy: StopTransmissionSpy!
    var subject: CurrentValueSubject<PTTTransmissionState, Never>!
    lazy var reducer: TransmissionReducer = {
        TransmissionReducer(
                startTransmission: startTransmissionSpy,
                stopTransmission: stopTransmissionSpy
        )
    }()

    override func setUp() {
        subject = CurrentValueSubject(.idle)
        startTransmissionSpy = StartTransmissionSpy()
        stopTransmissionSpy = StopTransmissionSpy()
    }

    func testEmitIdleShouldExecuteStartTransmission() {
        subject.send(.idle)
        reducer.on(subject: subject)

        XCTAssertEqual(1, startTransmissionSpy.executionCount)
    }

    func testEmitStartedShouldExecuteStopTransmission() {
        subject.send(.started)
        reducer.on(subject: subject)

        XCTAssertEqual(1, stopTransmissionSpy.executionCount)
    }

}

class StartTransmissionSpy: StartTransmissionUseCase {
    var executionCount = 0
    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>) {
        executionCount += 1
    }
}

class StopTransmissionSpy: StopTransmissionUseCase {
    var executionCount = 0
    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>) {
        executionCount += 1
    }
}