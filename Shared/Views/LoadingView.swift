//
//  LoadingView.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2020-11-30.
//

import SwiftUI

struct LoadingView: View {
    @EnvironmentObject var loginState: LoginManager

    var body: some View {
        HStack {
            VStack {
                ProgressView()
            }
        }
        #if os(macOS)
            .frame(width: maxFrameWidth, height: maxFrameHeight)
        #endif
        .onAppear(perform: {
            Task(priority: .userInitiated, operation: {
                let state = await loginState.loginFromKeychain()
                if state.authState != .authenticated || state.authState != .noCredentials {
                    loginState.state = state
                }
            })
        })
    }
}

struct LoadingView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingView()
    }
}
