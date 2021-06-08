//
//  Hacks.swift
//  iOS
//
//  Created by Spotlight Deveaux on 2021-06-08.
//

import Foundation
import UIKit

extension Bundle {
    var icon: UIImage? {
        guard
            let icons = infoDictionary?["CFBundleIcons"] as? [String: Any],
            let primaryIcon = icons["CFBundlePrimaryIcon"] as? [String: Any],
            let iconFiles = primaryIcon["CFBundleIconFiles"] as? [String],
            let lastIcon = iconFiles.last
        else {
            return nil
        }

        return UIImage(named: lastIcon)
    }
}
