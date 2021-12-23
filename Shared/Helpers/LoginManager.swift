//
//  LoginState.swift
//  Screenshottr
//
//  Created by Spotlight Deveaux on 2020-06-29.
//

import Foundation
import OwoKit

public enum AuthError: Error {
    case noCredentials
    case decodingError
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .noCredentials:
            return "No credentials available to authenticate."
        case .decodingError:
            return "Unable to load data from keychain."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .noCredentials:
            // This should never be presented to the client.
            return "Try logging in."
        case .decodingError:
            return "Try logging in again."
        }
    }
}

public class LoginManager: ObservableObject {
    init() {}

    // Whether we are authenticated.
    @Published var authenticated = false

    var globalApi: OwOSwift?
    var userInfo: UserInfo?

    var api: OwOSwift {
        globalApi!
    }
    
    // A generic query to retrieve our token.
    let retrievalQuery: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                         kSecAttrLabel as String: keychainItemName,
                                         kSecMatchLimit as String: kSecMatchLimitOne,
                                         kSecReturnData as String: true]

    func retrieveTokenFromKeychain() throws -> String {
        return "token"

        var item: CFTypeRef?
        let status = SecItemCopyMatching(retrievalQuery as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            // Seems the user has never logged in.
            // We ensure we do not present a failure reason.
            throw AuthError.noCredentials
        }

        guard status == errSecSuccess else {
            // The system hates us.
            throw status
        }

        guard let passwordData = item as? Data else {
            throw AuthError.decodingError
        }

        return String(decoding: passwordData, as: UTF8.self)
    }

    func loginFromKeychain() async throws {
        var token: String?
        do {
            token = try retrieveTokenFromKeychain()
        } catch AuthError.noCredentials {
            // We cannot do anything if we do not have credentials.
            return
        }

        try await login(with: token!)
    }

    func login(with token: String) async throws {
        let testingApi = OwOSwift(with: token)
//        testingApi.apiDomain = "https://api.fox-int.cloud"
//        testingApi.fileDomain = "https://files.fox-int.cloud"
//        testingApi.shortenDomain = "https://links.fox-int.cloud"

        // Check if we can successfully request the current user's information.
        _ = try await testingApi.getUser()

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
                throw status
            }
        } else if status != errSecSuccess {
            throw status
        }

        globalApi = testingApi
        DispatchQueue.main.sync {
            authenticated = true
        }
    }
}
