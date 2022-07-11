//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine
import XCTest

class IntegratedTests: XCTestCase {

    var controller: PTTController!
    var viewModel: PTTViewModel!

    var startTransmission: StartTransmission!
    var stopTransmission: StopTransmission!
    var reducer: TransmissionReducer!

    var signalingService: MockSignalingService!
    var transmissionService: MockTransmissionService!
    var errorService: MockErrorService!

    override func setUp() {
        viewModel = PTTViewModel()
        signalingService = MockSignalingService()
        transmissionService = MockTransmissionService()
        errorService = MockErrorService()
        startTransmission = StartTransmission(
                signalingService, transmissionService, MockTonePlayer(), errorService
        )
        stopTransmission = StopTransmission(
                signalingService, transmissionService, MockTonePlayer()
        )
        reducer = TransmissionReducer(startTransmission: startTransmission, stopTransmission: stopTransmission)
        controller = PTTController(viewModel: viewModel, transmissionReducer: reducer)
    }


    //MARK: START TESTS
    func testShouldStartTransmission() {
        controller.togglePTT() // start

        XCTAssertEqual(PTTTransmissionState.started, viewModel.pttSubject.value)
    }

    func testShouldNotStartTransmission_WhenChannelIsBusy() {
        signalingService.mockReturn = false
        controller.togglePTT() // start

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.pttSubject.value)
    }

    func testShouldNotStartTransmission_WhenRTCError() {
        transmissionService.shouldThrowStartError = true
        controller.togglePTT() // start

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.pttSubject.value)
    }

    func testEmitError_WhenRTCError() {
        transmissionService.shouldThrowStartError = true
        controller.togglePTT() // start

        XCTAssertEqual("The operation couldn’t be completed. (Random START Transmission error error 123.)", errorService.errorQueue.last)
    }

    //MARK: STOP TESTS
    func testShouldStopTransmission() {
        viewModel.pttSubject.value = .started
        controller.togglePTT() // stop

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.pttSubject.value)
    }

    func testShouldStopTransmission_EvenWithError() {
        viewModel.pttSubject.value = .started
        signalingService.informEndOfSpeechThrowError = true
        controller.togglePTT() // stop

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.pttSubject.value)
    }

    //MARK: Other Tests
    func testShouldToggleMultipleTimes() {
        controller.togglePTT() // start
        XCTAssertEqual(PTTTransmissionState.started, viewModel.pttSubject.value)

        controller.togglePTT() // stop
        XCTAssertEqual(PTTTransmissionState.idle, viewModel.pttSubject.value)

        controller.togglePTT() // start
        XCTAssertEqual(PTTTransmissionState.started, viewModel.pttSubject.value)
    }

    func testShouldEmitErrorWhenFailsDuringTransmission() {
        TransmissionViewModel(
                transmissionService: transmissionService,
                errorService: errorService,
                pttSubject: viewModel.pttSubject
        )

        controller.togglePTT() // start
        transmissionService.subject.send(.transmitError) // emit error in mid transmission
        XCTAssertEqual("Deu ruim aqui meu irmão ;-;", errorService.errorQueue.last)
    }

    func testShouldStopTransmissionWhenFailsDuringTransmission() {
        TransmissionViewModel(
                transmissionService: transmissionService,
                errorService: errorService,
                pttSubject: viewModel.pttSubject
        )

        controller.togglePTT() // start
        transmissionService.subject.send(.transmitError) // emit error in mid transmission

        XCTAssertEqual(.idle, viewModel.pttSubject.value)
    }

}