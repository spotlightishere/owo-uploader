//
//  Sidebar.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2021-06-15.
//

import SwiftUI

struct Sidebar: View {
    var body: some View {
        #if os(iOS)
            // We only want TabView on iOS because it's awful elsewhere.
            TabView {
                Text("Files")
                    .tabItem {
                        Image(systemName: "folder")
                        Text("Files")
                    }
                Text("Upload")
                    .tabItem {
                        Image(systemName: "square.and.arrow.up")
                        Text("Upload")
                    }
            }
        #else
            List {
                Group {
                    Label("Files", systemImage: "folder")
                    Label("Upload", systemImage: "square.and.arrow.up")
                }
            }.listStyle(.sidebar)
        #endif
    }
}

struct Sidebar_Previews: PreviewProvider {
    static var previews: some View {
        Sidebar()
    }
}
