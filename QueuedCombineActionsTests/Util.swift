//
// Created by Bruno on 07/07/22.
//

import Foundation

func delay(millis: Double) {
    usleep(useconds_t(millis * 1000))
}

func getCurrentTime() -> String {
    // 1. Choose a date
    let today = Date()
    // 2. Pick the date components
    let hours   = (Calendar.current.component(.hour, from: today))
    let minutes = (Calendar.current.component(.minute, from: today))
    let seconds = (Calendar.current.component(.second, from: today))
    let nanosecond = (Calendar.current.component(.nanosecond, from: today))
    // 3. Show the time
    return "\(hours):\(minutes):\(seconds) \(nanosecond)"
}