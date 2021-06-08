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
    private var loginState = LoginState()
    public var globalApi: OwOSwift = OwOSwift()
    
    init() {
        authenticate()
    }
    
    func authenticate() {
        loginState.loginFromKeychain()
    }
    
    var body: some Scene {
        let group = WindowGroup {
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
        return group.windowStyle(HiddenTitleBarWindowStyle())
        #else
        return group
        #endif
    }
}
