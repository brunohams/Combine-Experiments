//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

class TransmissionViewModel {

    private var cancellables = Set<AnyCancellable>()

    private let transmissionService: TransmissionService
    private let errorService: ErrorService
    private let pttSubject: CurrentValueSubject<PTTTransmissionState, Never>

    init(transmissionService: TransmissionService,
         errorService: ErrorService,
         pttSubject: CurrentValueSubject<PTTTransmissionState, Never>) {

        self.transmissionService = transmissionService
        self.pttSubject = pttSubject
        self.errorService = errorService
        print("TransmissionViewModel : \(Unmanaged.passUnretained(self.pttSubject).toOpaque())")

        subscribe(to: transmissionService.subject)
    }

    private func subscribe(to transmissionSubject: PassthroughSubject<TransmissionStatus, Never>) {
        transmissionSubject.sink { [self] status in
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
        }.store(in: &cancellables)
    }

}