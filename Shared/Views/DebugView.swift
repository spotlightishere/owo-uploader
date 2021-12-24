//
//  DebugView.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2021-12-24.
//

import SwiftUI
import OwoKit

struct DebugView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Base Domains"),
                    footer: Text("You can manually override utilized domains for testing.")
                ) {
                    DefaultsTextField(name: "API Domain", key: .apiDomain)
                    DefaultsTextField(name: "Upload Domain", key: .uploadDomain)
                    DefaultsTextField(name: "Shorten Domain", key: .shortenDomain)
                }
            }.navigationTitle("Debug Settings")
            #if os(macOS)
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        Button(action: {
                            dismiss()
                        }) {
                            Text("Done")
                        }
                    }
                }
            #else
                .navigationBarItems(trailing: Button(action: {
                    dismiss()
                }) {
                    Text("Done").bold()
                })
            #endif
        }
    }
}

struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DebugView()
        }
    }
}
