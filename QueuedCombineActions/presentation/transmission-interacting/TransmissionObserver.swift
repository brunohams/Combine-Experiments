//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

class TransmissionObserver {

    private var cancellables = Set<AnyCancellable>()
    private let transmissionService: TransmissionService
    private var controller: TransmissionController

    init(transmissionService: TransmissionService, controller: TransmissionController) {
        self.transmissionService = transmissionService
        self.controller = controller
        subscribe(to: transmissionService.subject)
    }

    private func subscribe(to transmissionSubject: PassthroughSubject<TransmissionStatus, Never>) {
        transmissionSubject
            .sink { [self] status in controller.on(status) }
            .store(in: &cancellables)
    }

}