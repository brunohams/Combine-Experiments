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
        rtcService.shouldThrowError = true
        await useCase.execute()

        XCTAssertEqual(presenter.emissions, ["Deu ruim"])
    }

    func testShouldWaitIfCalledMultipleTimes() async throws {
        rtcService.shouldThrowError = true
        await useCase.execute()
        XCTAssertEqual(presenter.emissions, ["Deu ruim"])

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
        delay(millis: 500)
        if shouldThrowError {
            throw NSError.init(domain: ("Random error"), code: 123)
        }

        return channelIsFree

    }

    func informEndOfTransmission() async throws {
        delay(millis: 500)
        if shouldThrowError {
            throw NSError.init(domain: ("Random error"), code: 123)
        }

    }

}

class RTCMockService: RTCService {

    var shouldThrowError = false
    private let publisher = PassthroughSubject<String, Never>()

    func startTransmission() -> AnyPublisher<String, Never> {
        Task {
            delay(millis: 100)
            publisher.send("Connectando...")
            delay(millis: 100)
            publisher.send("Connectado")
            delay(millis: 300)
            if shouldThrowError {
                publisher.send("Erro")
            } else {
                publisher.send("Transmissao iniciada")
            }
        }
        return publisher.eraseToAnyPublisher()
    }

    func stopTransmission() -> AnyPublisher<String, Never> {
        Task {
            delay(millis: 300)
            if shouldThrowError {
                publisher.send("Erro")
            } else {
                publisher.send("Transmissao finalizada")
            }
        }
        return publisher.eraseToAnyPublisher()
    }

}