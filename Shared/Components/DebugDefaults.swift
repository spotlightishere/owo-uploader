//
//  DebugDefaults.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2021-12-24.
//

import SwiftUI
import OwoKit

struct DefaultsTextField: View {
    let key: OwoDefaultsKeys
    let name: String
    @State private var valueField = ""
    
    init(name: String, key: OwoDefaultsKeys) {
        self.name = name
        self.key = key
        valueField = key.value ?? ""
    }
    
    var body: some View {
        TextField(name, text: $valueField)
            .onSubmit {
                // If our value is empty, delete the key.
                // Otherwise, we should update its value.
                if valueField.isEmpty {
                    UserDefaults.standard.removeObject(forKey: key.rawValue)
                } else {
                    UserDefaults.standard.set(valueField, forKey: key.rawValue)
                }
            }
    }
}
