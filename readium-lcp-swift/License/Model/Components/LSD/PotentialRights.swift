//
//  PotentialRights.swift
//  readium-lcp-swift
//
//  Created by Alexandre Camilleri on 9/13/17.
//
//  Copyright 2018 Readium Foundation. All rights reserved.
//  Use of this source code is governed by a BSD-style license which is detailed
//  in the LICENSE file present in the project repository where this source code is maintained.
//

import Foundation

public struct PotentialRights {
    
    /// Time and Date when the license ends.
    public let end: Date?

    init(json: [String: Any]) throws {
        self.end = (json["end"] as? String)?.dateFromISO8601
    }
    
}
