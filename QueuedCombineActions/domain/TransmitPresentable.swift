//
// Created by Bruno on 07/07/22.
//

import Foundation
import Combine

protocol TransmitPresentable {
    func subscribe(to publisher: AnyPublisher<String, Never>)
}
