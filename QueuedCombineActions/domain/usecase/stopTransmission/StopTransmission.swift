//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

protocol StopTransmissionUseCase {
    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>)
}

class StopTransmission: StopTransmissionUseCase {

    let signalingService: SignalingService
    let transmissionService: TransmissionService
    let tonePlayer: TonePlayer

    init (_ signalingService: SignalingService,
          _ transmissionService: TransmissionService,
          _ tonePlayer: TonePlayer) {
        self.signalingService = signalingService
        self.transmissionService = transmissionService
        self.tonePlayer = tonePlayer
    }

    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>) {
        try? signalingService.informEndOfSpeech()
        try? transmissionService.stop()

        subject.send(.idle)
    }
}