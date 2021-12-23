//
//  Structures.swift
//  OwoKit
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import Alamofire
import Foundation

/// Base holds the only common field across all requests, error or not.
struct Base: Codable {
    var success: Bool
}

/// ErrorInfo permits scraping error information from the API.
struct ErrorInfo: Codable, Equatable {
    var errorCode: Int
    var description: String

    enum CodingKeys: String, CodingKey {
        case description
        case errorCode = "errorcode"
    }
}

/// User wraps the base user request, permiting extraction of user info.
struct User: Codable {
    let user: UserInfo
}

/// UserInfo describes information retrieved for the current user.
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

/// A type representing possible object types.
public enum ObjectType: Int, Codable {
    
    case file = 0
    case link = 1
    case tombstone = 2
}


/// A type representing metadata for objects.
public struct Object: Codable, Hashable {
    /// The name of the bucket this object is served from.
    public var bucketName: String
    /// The path this object is accessible from via any base domain.
    public var key: String
    /// The directory this file is served from via any base domain.
    public var dir: String
    /// The type of this object.
    public var type: ObjectType
    /// Represents the destination URL this object goes to, should the object be a link.
    /// If it is anything else, the destination URL will be nil.
    public var destinationURL: URL?
    /// The MIME type of this file.
    public var contentType: String
    /// The size of this object, in bytes. Nil if this object is a link.
    public var contentLength: Int
    /// The date this object was created.
    public var createdAt: String
    /// The date this object was deleted. Nil if the object is still available.
    public var deletedAt: String?
    /// The reason this object was deleted. Nil if the object is still available.
    public var deletionReason: String?
    /// The MD5 hash of this object.
    public var md5: String
    /// The SHA-256 hash of this object.
    public var sha256: String
    /// Whether this object is associated to the authenticated user.
    public var associated: Bool
    
    enum CodingKeys: String, CodingKey {
        case key, dir, type
        case bucketName = "bucket"
        case destinationURL = "dest_url"
        case contentType = "content_type"
        case contentLength = "content_length"
        case createdAt = "created_at"
        case deletedAt = "deleted_at"
        case deletionReason = "delete_reason"
        case md5 = "md5_hash"
        case sha256 = "sha256_hash"
        case associated = "associated_with_current_user"
    }
    
    /// A usable thumbnail URL for the given object.
    public var thumbnailURL: URL {
        return URL(string: defaultUploadDomain + key + "?thumbnail")!
    }
    
    /// A usable filename.
    public var filename: String {
        return String(key.dropFirst())
    }
}

/// Object represents information about a specific object.
public struct ObjectQuery: Codable {
    public var data: Object
}

/// ObjectList represents information about the resulting array of returned objects.
public struct ObjectList: Codable {
    public var totalObjects: Int
    public var objects: [Object]
    
    enum CodingKeys: String, CodingKey {
        case totalObjects = "total_objects"
        case objects = "data"
    }
}
