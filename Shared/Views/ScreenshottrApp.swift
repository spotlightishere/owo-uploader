//
//  ScreenshottrApp.swift
//  Shared
//
//  Created by Spotlight Deveaux on 6/26/20.
//

import owo_swift
import SwiftUI

@main
struct ScreenshottrApp: App {
    @StateObject var loginState = LoginManager()

    var body: some Scene {
        WindowGroup {
            if loginState.state.authState == .initialLaunch {
                LoadingView().environmentObject(loginState)
            } else if loginState.state.authState == .authenticated {
                MainView().environmentObject(loginState)
            } else {
                LoginView().environmentObject(loginState)
            }
        }
        #if os(macOS)
            // We'd prefer to have the group's title bar hidden where possible.
            .windowStyle(.hiddenTitleBar)
        #endif
    }
}
