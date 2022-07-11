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

        XCTAssertEqual(PTTTransmissionState.started, viewModel.statePublisher.value)
    }

    func testShouldNotStartTransmission_WhenChannelIsBusy() {
        signalingService.mockReturn = false
        controller.togglePTT() // start

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.statePublisher.value)
    }

    func testShouldNotStartTransmission_WhenRTCError() {
        transmissionService.shouldThrowStartError = true
        controller.togglePTT() // start

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.statePublisher.value)
    }

    func testEmitError_WhenRTCError() {
        transmissionService.shouldThrowStartError = true
        controller.togglePTT() // start

        XCTAssertEqual("The operation couldn’t be completed. (Random START Transmission error error 123.)", errorService.errorQueue.last)
    }

    //MARK: STOP TESTS
    func testShouldStopTransmission() {
        viewModel.statePublisher.value = .started
        controller.togglePTT() // stop

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.statePublisher.value)
    }

    func testShouldStopTransmission_EvenWithError() {
        viewModel.statePublisher.value = .started
        signalingService.informEndOfSpeechThrowError = true
        controller.togglePTT() // stop

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.statePublisher.value)
    }

    func testShouldToggleMultipleTimes() {
        controller.togglePTT() // start
        XCTAssertEqual(PTTTransmissionState.started, viewModel.statePublisher.value)

        controller.togglePTT() // stop
        XCTAssertEqual(PTTTransmissionState.idle, viewModel.statePublisher.value)

        controller.togglePTT() // start
        XCTAssertEqual(PTTTransmissionState.started, viewModel.statePublisher.value)
    }

}