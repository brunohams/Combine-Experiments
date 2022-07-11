//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

protocol StartTransmissionUseCase {
    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>)
}

class StartTransmission: StartTransmissionUseCase {
    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>) {
        // nossos paranue
        subject.send(.started)
    }
}