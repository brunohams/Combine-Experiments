//
// Created by Bruno on 07/07/22.
//

import Foundation
import Combine

protocol RTCService {
    var eventPublisher: PassthroughSubject<String, Never> { get }

    func startTransmission() async throws
    func stopTransmission() async throws
}

enum RTCServiceError: Error {
    case failToStartTransmission
    case failToStopTransmission
}