//
// Created by Bruno on 07/07/22.
//

import Foundation

protocol SignalingService {
    func requestToStartTransmission() async throws -> Bool
    func informEndOfTransmission() async throws
}

enum SignalingServiceError: Error {
    case failToRequestStart
    case failToInformEnd
}