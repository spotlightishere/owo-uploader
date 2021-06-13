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
    private let loginState = LoginManager.shared

    init() {
        authenticate()
    }

    func authenticate() {
        loginState.loginFromKeychain()
    }

    var body: some Scene {
        WindowGroup {
            if loginState.authState == .initialLaunch {
                LoadingView()
            } else if loginState.authState != .authenticated {
                LoginView().environmentObject(loginState)
            } else {
                MainView()
            }
        }
#if os(macOS)
        // We'd prefer to have the group's title bar hidden where possible.
        .windowStyle(HiddenTitleBarWindowStyle())
#endif
    }
}
