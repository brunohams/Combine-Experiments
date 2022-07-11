//
// Created by PremierSoft on 11/07/22.
//

import Foundation

class MockErrorService: ErrorService {

    var errorQueue: [String] = []

    func enqueue(error: String) {
        errorQueue.append(error)
    }
}