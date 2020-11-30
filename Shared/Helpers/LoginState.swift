//
//  LoginState.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 6/29/20.
//

import Foundation

struct User {
    var username = ""
    var token = ""
}

class LoginState: ObservableObject {
    init() {}
    
    @Published var user: User? = nil
    @Published var failureReason: String = ""
    @Published var isLoggingIn: Bool = false
    
    func login(with token: String) {
        self.isLoggingIn = true
        self.failureReason = ""
        
        print(token)
    }
}
