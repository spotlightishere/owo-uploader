//
//  Hacks.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2020-06-29.
//

import AppKit
import Foundation

extension Bundle {
    var icon: NSImage {
        NSImage(imageLiteralResourceName: NSImage.applicationIconName)
    }
}
