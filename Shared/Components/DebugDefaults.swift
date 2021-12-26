//
//  DebugDefaults.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2021-12-24.
//

import OwoKit
import SwiftUI

struct DefaultsTextField: View {
    let key: OwoDefaultsKeys
    let name: String
    @State private var valueField = ""

    var body: some View {
        TextField(name, text: $valueField)
            .onAppear {
                valueField = key.value ?? ""
            }
            .onChange(of: valueField) { value in
                // If our value is empty, delete the key.
                // Otherwise, we should update its value.
                if valueField.isEmpty {
                    UserDefaults.standard.removeObject(forKey: key.rawValue)
                } else {
                    UserDefaults.standard.set(value, forKey: key.rawValue)
                    print("updated \(key.rawValue) with \(value)")
                }
            }
    }
}
