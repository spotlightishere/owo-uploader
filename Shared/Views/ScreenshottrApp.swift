//
//  ScreenshottrApp.swift
//  Shared
//
//  Created by Spotlight Deveaux on 2020-06-29.
//

import OwoKit
import SwiftUI

@main
struct ScreenshottrApp: App {
    @StateObject var loginState = LoginManager()

    var body: some Scene {
        WindowGroup {
            if loginState.authenticated {
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
