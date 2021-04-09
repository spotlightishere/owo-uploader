//
//  LoadingView.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2020-11-30.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        let stack = HStack {
            VStack {
                ProgressView()
            }
        }
        #if os(macOS)
        // Under macOS, we want the window to be a proper size.
        // TODO: 518 is adjusted from 546. Title bar size may vary.
        return stack.frame(width: 646.0, height: 518.0)
        #else
        return stack
        #endif

    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
