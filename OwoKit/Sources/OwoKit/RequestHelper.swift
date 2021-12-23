//
//  RequestHelper.swift
//  OwoKit
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import Alamofire
import Foundation

public extension DataResponse {
    func getSuccess<Value: Decodable>() throws -> Value {
        var result: Value

        switch self.result {
        case let .success(parsedValue):
            result = parsedValue as! Value
        case let .failure(error):
            throw error
        }

        return result
    }
}

public extension DataRequest {
    func handle<Value: Decodable>(type givenType: Value.Type = Value.self) async throws -> Value {
        // Check success first.
        let initialResponse = await serializingDecodable(Base.self).response
        let successBody: Base = try initialResponse.getSuccess()

        if successBody.success == false {
            // If possible, we'll throw an error with the information given by the API.
            let error = await serializingDecodable(ErrorInfo.self).response
            let errorInfo: ErrorInfo = try error.getSuccess()

            // We may have an authentication-related error.
            if errorInfo.errorCode == 401, errorInfo.description == "bad token" {
                throw APIError.invalidToken
            } else {
                throw APIError.serviceError(errorCode: errorInfo.errorCode, reason: errorInfo.description)
            }
        } else {
            // We have no error, so we can return what the user specified.
            return try await serializingDecodable(givenType).response.getSuccess()
        }
    }
}
