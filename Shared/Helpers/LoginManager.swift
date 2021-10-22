//
//  LoginState.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 6/29/20.
//

import Foundation
import owo_swift

public enum AuthState: Error {
    case initialLaunch
    case noCredentials
    case invalidAuth
    case authenticated
}

public struct LoginState {
    /// The current state of login.
    var authState: AuthState = .initialLaunch
    /// Given failure reason for the assigned state.
    var failureReason = ""
}

public class LoginManager: ObservableObject {
    init() {}

    // Are we currently logging in?
    // Used to guide the appearance of
    // and prevent two login calls at once.
    @Published var isLoggingIn = false

    // The overall state of this manager.
    @Published var state = LoginState()

    var globalApi: OwOSwift?

    /// Publishes the current authentication state and its failure reason.
    /// - Parameters:
    ///   - state: The state to change to.
    ///   - reason: The reason to state for the UI.
    private func changeState(_ state: AuthState, reason: String) -> LoginState {
        // TODO: Figure out a better way to manage this.
        return LoginState(authState: state, failureReason: reason)
    }
    
    private func changeStateToken(_ state: AuthState, reason: String) -> (String?, LoginState?) {
        return (nil, changeState(state, reason: reason))
    }

    func getErrorReason(_ givenReason: OSStatus) -> String {
        let reserved: UnsafeMutableRawPointer? = nil
        let cfReason = SecCopyErrorMessageString(givenReason, reserved)

        if cfReason == nil {
            return "Unknown error"
        } else {
            return cfReason! as String
        }
    }

    // A generic query to retrieve our token.
    let retrievalQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                         kSecAttrLabel as String: keychainItemName,
                                         kSecMatchLimit as String: kSecMatchLimitOne,
                                         kSecReturnData as String: true]

    func retrieveTokenFromKeychain() -> (String?, LoginState?) {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(retrievalQuery as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            // Seems the user has never logged in.
            // We ensure we do not present a failure reason.
            return changeStateToken(.noCredentials, reason: "")
        }

        guard status == errSecSuccess else {
            // The system hates us.
            return changeStateToken(.invalidAuth, reason: getErrorReason(status))
        }

        guard let passwordData = item as? Data else {
            return changeStateToken(.noCredentials, reason: "Unable to load data from keychain.")
        }
        
        return (String(decoding: passwordData, as: UTF8.self), nil)
    }

    func loginFromKeychain() async -> LoginState {
        let (possibleToken, authState) = retrieveTokenFromKeychain()
        if authState == nil {
            return authState!
        }

        if state.authState == .noCredentials || possibleToken == nil {
            print("User is logged out. Performing no action.")
            return changeState(.noCredentials, reason: "")
        }

        if state.authState != .initialLaunch {
            return changeState(.noCredentials, reason: "An external error occurred retrieving keychain credentials.")
        }

        guard let token = possibleToken else {
            return changeState(.noCredentials, reason: "Unable to load data from keychain.")
        }

        return await login(with: token)
    }

    func login(with token: String) async -> LoginState {
        isLoggingIn = true
        state.failureReason = ""

        globalApi = OwOSwift(with: token)
        do {
            globalApi?.apiDomain = "https://api.fox-int.cloud"
            globalApi?.fileDomain = "https://files.fox-int.cloud"
            globalApi?.shortenDomain = "https://links.fox-int.cloud"

            // Check if we can successfully request the current user's information.
            _ = try await globalApi!.getUser()


            // Add this new, valid token to the keychain.
            let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                        kSecAttrLabel as String: keychainItemName,
                                        kSecValueData as String: token.data(using: String.Encoding.utf8)!]

            let status = SecItemAdd(query as CFDictionary, nil)
            if status == errSecDuplicateItem {
                // If needed, update the existing keychain item with our new token.
                let updatedData: [String: Any] = [kSecValueData as String: token.data(using: String.Encoding.utf8)!]
                let status = SecItemUpdate(retrievalQuery as CFDictionary, updatedData as CFDictionary)
                guard status == errSecSuccess else {
                    return changeState(.invalidAuth, reason: "Unable to update token in keychain. \(status)")
                }
                
                // Successfully updated!
                return changeState(.authenticated, reason: "")
            } else if status != errSecSuccess {
                return changeState(.invalidAuth, reason: "Unable to save token to keychain. \(status)")
            }
        } catch APIError.invalidToken {
            return changeState(.invalidAuth, reason: "Invalid token.")
        } catch let e {
            return changeState(.invalidAuth, reason: e.localizedDescription)
        }
        
        return changeState(.invalidAuth, reason: "An unknown error occurred.")
    }
}
