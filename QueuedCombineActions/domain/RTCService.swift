//
// Created by Bruno on 07/07/22.
//

import Foundation
import Combine

protocol RTCService {
    func startTransmission() -> AnyPublisher<String, Never>
    func stopTransmission() -> AnyPublisher<String, Never>
}