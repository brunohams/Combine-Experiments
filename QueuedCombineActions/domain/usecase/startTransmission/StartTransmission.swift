//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

protocol StartTransmissionUseCase {
    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>)
}

class StartTransmission: StartTransmissionUseCase {

    let signalingService: SignalingService
    let transmissionService: TransmissionService
    let tonePlayer: TonePlayer
    let errorService: ErrorService

    init (_ signalingService: SignalingService,
          _ transmissionService: TransmissionService,
          _ tonePlayer: TonePlayer,
          _ errorService: ErrorService) {
        self.signalingService = signalingService
        self.transmissionService = transmissionService
        self.tonePlayer = tonePlayer
        self.errorService = errorService
    }

    func execute(_ subject: CurrentValueSubject<PTTTransmissionState, Never>) {
        subject.send(.starting)

        do {
            if try signalingService.requestToTalk() {
                try transmissionService.start()
                tonePlayer.playStartTone()
                subject.send(.started)
            } else {
                subject.send(.idle)
            }
        } catch {
            errorService.enqueue(error: error.localizedDescription)
            subject.send(.idle)
        }

    }
}