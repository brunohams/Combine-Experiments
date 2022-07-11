//
// Created by PremierSoft on 11/07/22.
//

import Foundation

protocol SignalingService {
    func requestToTalk() throws -> Bool
    func informEndOfSpeech() throws
}