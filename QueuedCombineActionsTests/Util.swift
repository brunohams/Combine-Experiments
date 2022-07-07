//
// Created by Bruno on 07/07/22.
//

import Foundation

func delay(millis: Double) {
    usleep(useconds_t(millis * 10000))
}