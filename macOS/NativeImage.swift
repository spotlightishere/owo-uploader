//
//  NativeImage.swift
//  macOS
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import AppKit
import SwiftUI

public extension Image {
    init(image: NSImage) {
        self.init(nsImage: image)
    }
}
