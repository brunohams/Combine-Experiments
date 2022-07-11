//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

class PTTViewModel {

    var cancellables = Set<AnyCancellable>()
    let pttSubject = CurrentValueSubject<PTTTransmissionState, Never>(.idle)

    init() {

        pttSubject.sink { state in
            switch state {
            case .idle:
                break
            case .starting:
                break
            case .started:
                break
            case .receiving:
                break
            }
        }.store(in: &cancellables)
    }

}
