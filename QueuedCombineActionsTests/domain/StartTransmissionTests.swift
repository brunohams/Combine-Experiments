//
// Created by Bruno on 07/07/22.
//

import XCTest
import Foundation
import Combine

class StartTransmissionTests: XCTestCase {

    var rtcService: RTCMockService!
    var signalingService: SignalingMockService!
    var presenter: DummyPresenter!
    var useCase: StartTransmission {
        StartTransmission(
                rtcService: rtcService,
                signalingService: signalingService,
                presenter: presenter
        )
    }

    override func setUpWithError() throws {
        presenter = DummyPresenter()
        signalingService = SignalingMockService()
        rtcService = RTCMockService()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }


    func testShouldCallAndWaitStartTransmission() async throws {
        await useCase.execute()

        XCTAssertEqual(presenter.emissions, ["Pode Falar"])
    }


    func testShouldCallAndWaitStartTransmission_WithSIGNALINGError() async throws {
        signalingService.shouldThrowError = true
        await useCase.execute()

        XCTAssertEqual(presenter.emissions, ["Deu ruim"])
    }


    func testShouldCallAndWaitStartTransmission_WithRTCError() async throws {
        rtcService.shouldThrowErrorOnStart = true
        await useCase.execute()

        XCTAssertEqual(presenter.emissions, ["Pode parar de falar", "Deu ruim"])
    }

    func testShouldWaitIfCalledMultipleTimes() async throws {
        rtcService.shouldThrowErrorOnStart = true
        await useCase.execute()
        XCTAssertEqual(presenter.emissions, ["Pode parar de falar", "Deu ruim"])

        try setUpWithError()

        await useCase.execute()
        XCTAssertEqual(presenter.emissions, ["Pode Falar"])
    }
}

class DummyPresenter: StartTransmissionPresentable {

    var emissions = [String]()
    var cancellable = Set<AnyCancellable>()

    func subscribe(to publisher: AnyPublisher<String, Never>) {
        publisher.sink { value in
            self.emissions.append(value)
        }.store(in: &cancellable)
    }

}

class SignalingMockService: SignalingService {

    var shouldThrowError = false
    var channelIsFree = true

    func requestToStartTransmission() async throws -> Bool {
        delay(millis: 200)
        if shouldThrowError {
            throw SignalingServiceError.failToRequestStart
        }
        return channelIsFree
    }

    func informEndOfTransmission() async throws {
        delay(millis: 200)
        if shouldThrowError {
            throw SignalingServiceError.failToInformEnd
        }
    }

}

class RTCMockService: RTCService {

    var eventPublisher = PassthroughSubject<String, Never>()
    var shouldThrowErrorOnStart = false
    var shouldThrowErrorOnStop = false

    func startTransmission() async throws {
        delay(millis: 100)
        eventPublisher.send("Connectando...")
        delay(millis: 100)
        eventPublisher.send("Connectado")
        delay(millis: 300)
        if shouldThrowErrorOnStart {
            throw RTCServiceError.failToStartTransmission
        } else {
            eventPublisher.send("Transmissao iniciada")
            return
        }
    }

    func stopTransmission() async throws {
        delay(millis: 300)
        if shouldThrowErrorOnStop {
            throw RTCServiceError.failToStopTransmission
        } else {
            eventPublisher.send("Transmissao finalizada")
            return
        }
    }

}