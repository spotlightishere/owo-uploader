//
//  OwoKit.swift
//  OwoKit
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import Alamofire
import Foundation

/// Easily utilize the OwO Beta API to upload files,
/// shorten links, and list/delete associated files.
public class OwOSwift {
    /// The token used to authenticate a user with.
    private var token: String
    /// The domain to use as a base with all API routes.
    public var apiDomain = defaultAPIDomain
    /// The domain to append when uploading files.
    public var fileDomain = defaultUploadDomain
    /// The domain to append when shortening links.
    public var shortenDomain = defaultShortenDomain

    /// Initializes a usable OwOSwift object with the given token.
    /// All default domains are used, and the default API domain is set.
    /// - Parameter token: The token to authenticate the with.
    public init(with token: String) {
        self.token = token
    }

    /// Returns the base API domain concatenated with the specified route.
    /// - Parameter routePath: The string of the path intended to be concatenated.
    /// - Returns: A usable URL for the given route.
    private func route(for path: String) -> String {
        "\(apiDomain)\(path)"
    }

    /// Returns necessary headers for interacting with the API.
    /// - Returns: The proper Authorization and User-Agent for this request.
    private func getHeaders() -> HTTPHeaders {
        [
            "Authorization": token,
            "User-Agent": defaultUserAgent,
        ]
    }

    /// Returns a usable request with proper headers set for a GET request, including parameters.
    /// - Parameters:
    ///   - routePath: The route to make a GET request to.
    ///   - params: An array of parameters to set alongside this request.
    /// - Returns: A `DataRequest` usable to make the request with.
    private func getRequest(to routePath: String, params: Parameters?) -> DataRequest {
        AF.request(route(for: routePath), method: .get, parameters: params, headers: getHeaders())
    }
    
    /// Returns a usable request with proper headers set for a GET request.
    /// - Parameter routePath: The route to make a GET request to.
    /// - Returns: A `DataRequest` usable to make the request with.
    private func getRequest(to routePath: String) -> DataRequest {
        getRequest(to: routePath, params: nil)
    }
    
    /// Returns a usable request with proper headers set for a POST request.
    /// - Parameters:
    ///   - routePath: The route to make a POST request to.
    ///   - multipartForm: Files to be attached to this request.
    /// - Returns: A `DataRequest` usable to make the request with.
    private func uploadRequest(to routePath: String, multipartForm: MultipartFormData) -> DataRequest {
        AF.upload(multipartFormData: multipartForm, to: route(for: routePath), headers: getHeaders())
    }

    /// Queries the API for information related to the current user.
    /// - Returns: User account details for the given token
    public func getUser() async throws -> UserInfo {
        try await getRequest(to: "/users/me").handle(type: User.self).user
    }
    
    /// Queries the API for objects associated to the current user.
    /// - Parameters:
    ///   - limit: A cap of objects to query. Defaults to 100, the maximum.
    ///   - offset: The offset of objects to read, usable for pagination.
    /// - Returns: A listing of objects for the given token
    public func getObjects(limit: Int = 100, offset: Int = 0) async throws -> ObjectList {
        if limit > maxObjectLimit {
            throw APIError.exceedsMaxLimit
        }
        
        return try await getRequest(to: "/objects", params: ["limit": limit, "offset": offset]).handle(type: ObjectList.self)
    }
    
    /// Retrieves information about the object with the given key.
    /// - Parameter key: Alsk known as the dir of the object + filename + extension, it starts with a leading forward slash.
    /// - Returns: Object data
    public func getObject(key: String) async throws -> Object {
        try await getRequest(to: "/objects" + key).handle(type: ObjectQuery.self).data
    }
    
    /// Retrieves information about the object with the given filename.
    /// - Parameter filename: The filename, with an extension.
    /// - Returns: Object data
    public func getObject(filename: String) async throws -> Object {
        try await getObject(key: "/" + filename)
    }
}
