//
//  DebugView.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2021-12-24.
//

import OwoKit
import SwiftUI

struct DebugView: View {
    var body: some View {
        #if os(macOS)
            VStack(alignment: .center) {
                Text("Debug Settings")
                    .font(.title)
                    .padding()
                DebugFormView()
            }.padding()
                .frame(minWidth: 450.0, minHeight: 200.0)
        #else
            NavigationView {
                DebugFormView()
                    .navigationTitle("Debug Settings")
            }
        #endif
    }
}

struct DebugFormView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        Form {
            Section(
                header: Text("Base Domains"),
                footer: Text("You can manually override utilized domains for testing.")
            ) {
                DefaultsTextField(key: .apiDomain, name: "API Domain")
                DefaultsTextField(key: .uploadDomain, name: "Upload Domain")
                DefaultsTextField(key: .shortenDomain, name: "Shorten Domain")
            }

            Button("Done", action: {
                dismiss()
            })
        }
        #if os(macOS)
        .onExitCommand {
            dismiss()
        }
        #endif
    }
}

struct DebugFormView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DebugFormView()
        }
    }
}
