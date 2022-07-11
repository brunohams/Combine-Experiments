//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

protocol StopTransmissionUseCase {
    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>)
}

class StopTransmission: StopTransmissionUseCase {
    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>) {
        // nossos paranue
        subject.send(.idle)
    }
}