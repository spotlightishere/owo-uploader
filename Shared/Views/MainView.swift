//
//  MainView.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2020-06-29.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        VStack {
            Text("hi")
        }.toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: {
                    // todo
                }) {
                    Label("Upload", systemImage: "square.and.arrow.up")
                }
            }
        }

        #if os(macOS)
        .frame(width: maxFrameWidth, height: maxFrameHeight)
        #endif
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
