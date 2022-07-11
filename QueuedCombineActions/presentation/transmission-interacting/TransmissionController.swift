//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

class TransmissionController {

    private let errorService: ErrorService
    private let pttSubject: CurrentValueSubject<PTTTransmissionState, Never>

    init(errorService: ErrorService, pttSubject: CurrentValueSubject<PTTTransmissionState, Never>) {
        self.errorService = errorService
        self.pttSubject = pttSubject
    }

    func on(_ status: TransmissionStatus) {
        switch status {
        case .gatheringIce:
            break
        case .connectingToPeer:
            break
        case .connected:
            break
        case .transmitError:
            errorService.enqueue(error: "Deu ruim aqui meu irmão ;-;")
            pttSubject.send(.idle)
            print("receive transmit error")
        }
    }
}