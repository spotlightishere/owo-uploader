//
//  Hacks.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 6/27/20.
//

import AppKit
import Foundation

// We do not want any sort of focus ring.
// As this is not natively customizable in SwiftUI, disable globally.
// Sourced from https://stackoverflow.com/a/60290791
extension NSTextField {
    override open var focusRingType: NSFocusRingType {
        get { .none }
        set {}
    }
}
