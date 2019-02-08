//
//  LCPService.swift
//  r2-lcp-swift
//
//  Created by Mickaël Menu on 08.02.19.
//
//  Copyright 2019 Readium Foundation. All rights reserved.
//  Use of this source code is governed by a BSD-style license which is detailed
//  in the LICENSE file present in the project repository where this source code is maintained.
//

import Foundation
import R2Shared

/// Service used to fulfill and access protected publications.
/// If an LCPAuthenticating instance is not given when expected, the request is cancelled if no passphrase is found in the local database. This can be the desired behavior when trying to import a license in the background, without prompting the user for its passphrase.
public protocol LCPService {

    /// Imports a protected publication from a standalone LCPL file.
    func importLicenseDocument(_ lcpl: URL, authenticating: LCPAuthenticating?, completion: @escaping (LCPImportedPublication?, LCPError?) -> Void)
    
    /// Opens the LCP license of a protected publication, to access its DRM metadata and decipher its content.
    func openLicense(in publication: URL, authenticating: LCPAuthenticating?, completion: @escaping (LCPLicense?, LCPError?) -> Void) -> Void
    
}

/// Opened license, used to decipher a protected publication or read its DRM metadata.
public protocol LCPLicense: DrmLicense {
    
    /// Encryption profile.
    var profile: String { get }
    
}

public struct LCPImportedPublication {
    public let localUrl: URL
    public let downloadTask: URLSessionDownloadTask?
}

/// LCP service factory.
public func setupLCPService() -> LCPService {
    /// To modify depending of the profile of the liblcp.a used
    /// FIXME: Shouldn't the liblcp provide the supported profiles if it needs to be updated with it?
    let supportedProfiles = [
        "http://readium.org/lcp/basic-profile",
        "http://readium.org/lcp/profile-1.0",
    ]
    
    return LicensesService(supportedProfiles: supportedProfiles)
}