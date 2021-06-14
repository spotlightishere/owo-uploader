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
    private func changeState(_ state: AuthState, reason: String) {
        // TODO: Figure out a better way to manage this.
//        DispatchQueue.main.async {
            self.state = LoginState(authState: state, failureReason: reason)
            self.isLoggingIn = false
//        }
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

    func retrieveTokenFromKeychain() -> String? {
        var item: CFTypeRef?
        let status = SecItemCopyMatching(retrievalQuery as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            // Seems the user has never logged in.
            // We ensure we do not present a failure reason.
            changeState(.noCredentials, reason: "")
            return nil
        }

        guard status == errSecSuccess else {
            // The system hates us.
            changeState(.invalidAuth, reason: getErrorReason(status))
            return nil
        }

        guard let passwordData = item as? Data else {
            changeState(.noCredentials, reason: "Unable to load data from keychain.")
            return nil
        }

        return String(decoding: passwordData, as: UTF8.self)
    }

    func loginFromKeychain() async {
        let possibleToken = retrieveTokenFromKeychain()

        if state.authState == .noCredentials {
            print("User is logged out. Performing no action.")
            return
        }

        if state.authState != .initialLaunch {
            print("An external error occurred retrieving keychain credentials.")
            return
        }

        guard let token = possibleToken else {
            changeState(.noCredentials, reason: "Unable to load data from keychain.")
            return
        }

        print("success! retrieved \(token)")
        await login(with: token)
    }

    func login(with token: String) async {
        isLoggingIn = true
        state.failureReason = ""

        print("hello! authenticating with \(token)")

        globalApi = OwOSwift(with: token)
        do {
            globalApi?.apiDomain = "https://api.fox-int.cloud"
            globalApi?.fileDomain = "https://files.fox-int.cloud"
            globalApi?.shortenDomain = "https://links.fox-int.cloud"
            try await globalApi!.getUser()

            changeState(.authenticated, reason: "")

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
                    changeState(.invalidAuth, reason: "Unable to update token in keychain. \(status)")
                    return
                }
            } else if status != errSecSuccess {
                changeState(.invalidAuth, reason: "Unable to save token to keychain. \(status)")
                return
            }
        } catch APIError.invalidToken {
            changeState(.invalidAuth, reason: "Invalid token.")
        } catch let e {
            changeState(.invalidAuth, reason: e.localizedDescription)
        }
    }
}
