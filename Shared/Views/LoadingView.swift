//
//  LoadingView.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2020-11-30.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        HStack {
            VStack {
                ProgressView()
            }
        }
        #if os(macOS)
        .frame(width: maxFrameWidth, height: maxFrameHeight)
        #endif
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
