//
// Created by PremierSoft on 11/07/22.
//

import Foundation
import Combine

protocol TransmissionService {
    var subject: PassthroughSubject<TransmissionStatus, Never> { get } // TODO transformar em enum

    func start() throws
    func stop() throws
}

enum TransmissionStatus {
    case gatheringIce
    case connectingToPeer
    case connected
    case transmitError
}