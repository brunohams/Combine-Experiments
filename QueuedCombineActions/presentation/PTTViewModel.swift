//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

class PTTViewModel {

    let statePublisher = CurrentValueSubject<PTTTransmissionState, Never>(.idle)

    init() {
        statePublisher.sink { state in
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
        }
    }

}
