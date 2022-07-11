//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine
import XCTest

class IntegratedTests: XCTestCase {
    var startTransmission: StartTransmission!
    var stopTransmission: StopTransmission!
    var controller: PTTController!
    var viewModel: PTTViewModel!
    var reducer: TransmissionReducer!

    override func setUp() {
        startTransmission = StartTransmission()
        stopTransmission = StopTransmission()
        reducer = TransmissionReducer(startTransmission: startTransmission, stopTransmission: stopTransmission)
        viewModel = PTTViewModel()
        controller = PTTController(viewModel: viewModel, transmissionReducer: reducer)
    }

    func testShouldStartTransmission() {
        controller.togglePTT() // start

        XCTAssertEqual(PTTTransmissionState.started, viewModel.statePublisher.value)
    }

    func testShouldStopTransmission() {
        viewModel.statePublisher.value = .started
        controller.togglePTT() // stop

        XCTAssertEqual(PTTTransmissionState.idle, viewModel.statePublisher.value)
    }

    func testShouldToggleMultipleTimes() {
        controller.togglePTT() // start
        controller.togglePTT() // stop
        controller.togglePTT() // start

        XCTAssertEqual(PTTTransmissionState.started, viewModel.statePublisher.value)
    }

}