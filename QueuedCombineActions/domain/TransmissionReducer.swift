//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

class TransmissionReducer {

    private let startTransmission: StartTransmissionUseCase
    private let stopTransmission: StopTransmissionUseCase

    init(startTransmission: StartTransmissionUseCase, stopTransmission: StopTransmissionUseCase) {
        self.startTransmission = startTransmission
        self.stopTransmission = stopTransmission
    }

    func on(subject: CurrentValueSubject<PTTTransmissionState, Never>) {
        switch subject.value {
        case .idle:
            startTransmission.execute(subject)
        case .starting:
            cancelStartTransmission()
        case .started:
            stopTransmission.execute(subject)
        case .receiving:
            print("Nao pode transmitir, ja tem gente transmitindo")
        }
    }

    private func cancelStartTransmission() {
        // TODO
    }

}