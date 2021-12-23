//
//  OSStatus+Error.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import Foundation
import Security

func getErrorReason(_ givenReason: OSStatus) -> String {
    let reserved: UnsafeMutableRawPointer? = nil
    let cfReason = SecCopyErrorMessageString(givenReason, reserved)

    if cfReason == nil {
        return "Unknown error"
    } else {
        return cfReason! as String
    }
}

extension OSStatus: LocalizedError {
    public var errorDescription: String? {
        let errorReason = getErrorReason(self)
        return "The system returned an error: \"\(errorReason)\""
    }
}
