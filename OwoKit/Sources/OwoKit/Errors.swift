//
//  Errors.swift
//  OwoKit
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import Foundation

public enum APIError: Error {
    case serviceError(errorCode: Int, reason: String)
    case invalidToken
    case exceedsMaxLimit
}

extension APIError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .serviceError:
            return "The server returned an error."
        case .invalidToken:
            return "Invalid token."
        case .exceedsMaxLimit:
            return "Max limit exceeded"
        }
    }

    public var failureReason: String? {
        switch self {
        case let .serviceError(errorCode, reason):
            return "The server returned error code \(errorCode) with reason \(reason)."
        case .invalidToken:
            return "An invalid token was utilized."
        case .exceedsMaxLimit:
            return "The amount of objects queried was over the max limit possible."
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .serviceError:
            return "Try again at another time."
        case .invalidToken:
            return "Verify that your token is valid."
        case .exceedsMaxLimit:
            return "Ensure that the limit you've set while querying does not exceed \(maxObjectLimit)."
        }
    }
}
