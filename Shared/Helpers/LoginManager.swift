//
//  LoginState.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 6/29/20.
//

import Foundation
import owo_swift

struct User {
    var username = ""
    var token = ""
}

enum AuthState: Error {
    case initialLaunch
    case noCredentials
    case invalidAuth
    case authenticated
}

public class LoginManager: ObservableObject {
    init() {}
    
    public static let shared = LoginManager()
    
    // The current authenticated user, if available.
    @Published var user: User? = nil
    
    // Why did we fail?
    @Published var failureReason = ""
    
    // Are we currently logging in?
    // Used to guide the appearance of
    // and prevent two login calls at once.
    @Published var isLoggingIn = false
    
    // Are we attempting to log in on the app's launch?
    // This should be set to false once login was attempted
    // from the keychain.
    @Published var authState: AuthState = .initialLaunch
    
    
    var globalApi: OwOSwift?
    
    func getErrorReason(_ givenReason: OSStatus) -> String {
        let reserved: UnsafeMutableRawPointer? = nil
        let cfReason = SecCopyErrorMessageString(givenReason, reserved)
        
        if cfReason == nil {
            return "Unknown error"
        } else {
            return cfReason! as String
        }
    }
    
    func retrieveTokenFromKeychain() -> String? {
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecAttrLabel as String: keychainItemName,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            // Seems the user has never logged in.
            // We ensure we do not present a failure reason.
            failureReason = ""
            authState = .noCredentials
            
            return nil
        }
        
        guard status == errSecSuccess else {
            // The system hates us.
            failureReason = getErrorReason(status)
            authState = .invalidAuth
            
            return nil
        }
        
        guard let passwordData = item as? Data
        else {
            failureReason = "Unable to load data from keychain."
            authState = .invalidAuth
            
            return nil
        }
        
        return String(decoding: passwordData, as: UTF8.self)
    }
    
    func loginFromKeychain() {
        //        let possibleToken = retrieveTokenFromKeychain()
        let possibleToken: String? = ""
        
        if authState == .noCredentials {
            print("User is logged out. Performing no action.")
            return
        }
        
        if authState != .initialLaunch {
            print("An external error occurred retrieving keychain credentials.")
            authState = .noCredentials
            return
        }
        
        guard let token = possibleToken else {
            print("An external error occurred retrieving keychain credentials.")
            authState = .noCredentials
            return
        }
        
        print("success! retrieved \(token)")
        login(with: token)
    }
    
    func login(with token: String) {
        isLoggingIn = true
        failureReason = ""
        authState = .initialLaunch
        user?.token = token
        
        // TODO: WORK
        //        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
        //                                    kSecAttrLabel as String: keychainItemName,
        //                                    kSecValueData as String: token]
        //
        //        let status = SecItemAdd(query as CFDictionary, nil)
        //        guard status == errSecSuccess else {
        //            failureReason = "Unable to save token to keychain. \(status)"
        //            authState = .invalidAuth
        //            return
        //        }
        //
        print("hello! authenticating with \(token)")
        
        globalApi = OwOSwift(with: token)
    }
}
