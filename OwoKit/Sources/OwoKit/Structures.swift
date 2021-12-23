//
//  Structures.swift
//  OwoKit
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import Alamofire
import Foundation

public enum APIError: Error {
    case serviceError(errorCode: Int, reason: String)
    case invalidToken
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serviceError:
            return "The server returned an error."
        case .invalidToken:
            return "Invalid token."
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .serviceError(let errorCode, let reason):
            return "The server returned error code \(errorCode) with reason \(reason)."
        case .invalidToken:
            return "An invalid token was utilized."
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .serviceError:
            return "Try again at another time."
        case .invalidToken:
            return "Verify that your token is valid."
        }
    }
}

struct Base: Codable {
    var success: Bool
}

struct ErrorInfo: Codable, Equatable {
    var errorCode: Int
    var description: String

    enum CodingKeys: String, CodingKey {
        case description
        case errorCode = "errorcode"
    }
}

public struct User: Codable {
    let user: UserInfo
}

/// UserInfo describes
public struct UserInfo: Codable {
    var userId: String
    var username: String
    var email: String
    var isAdmin: Bool
    var isBlocked: Bool

    enum CodingKeys: String, CodingKey {
        case username, email
        case userId = "user_id"
        case isAdmin = "is_admin"
        case isBlocked = "is_blocked"
    }
}
