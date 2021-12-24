//
//  Constants.swift
//  OwoKit
//
//  Created by Spotlight Deveaux on 2021-12-23.
//

import Foundation

/// The current version of this package.
let version = "0.1.0"

/// A link to the repository this library is in.
let sourceUrl = "https://owo.codes/whats-this/OwoKit"

/// An usable User-Agent value in the service's documented format.
let defaultUserAgent = "WhatsThisClient (\(sourceUrl), \(version))"

/// The default domain to utilize the API with.
/// Searchs user defaults for OwoKitAPIDomain, or utilizes the main API domain.
var apiDomain: String {
    UserDefaults.standard.string(forKey: "OwoKitAPIDomain") ?? "https://api.awau.moe"
}

/// The default domain used for uploaded files.
var uploadDomain: String {
    UserDefaults.standard.string(forKey: "OwoKitUploadDomain") ?? "https://owo.whats-th.is"
}

/// The default domain used for shortened links.
var shortenDomain: String {
    UserDefaults.standard.string(forKey: "OwoKitShortenDomain") ?? "https://awau.moe"
}

let maxObjectLimit = 100
