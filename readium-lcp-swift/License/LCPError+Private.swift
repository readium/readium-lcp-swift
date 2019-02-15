//
//  LCPError+Private.swift
//  r2-lcp-swift
//
//  Created by Mickaël Menu on 14.02.19.
//
//  Copyright 2019 Readium Foundation. All rights reserved.
//  Use of this source code is governed by a BSD-style license which is detailed
//  in the LICENSE file present in the project repository where this source code is maintained.
//

import Foundation

extension LCPError {
    
    static func wrap(_ optionalError: Error?) -> LCPError {
        guard let error = optionalError else {
            return .unknown(nil)
        }
        
        if let error = error as? LCPError {
            return error
        } else if let error = error as? StatusError {
            return .licenseStatus(error)
        } else if let error = error as? ParsingError {
            return .parsing(error)
        }
        
        let nsError = error as NSError
        switch nsError.domain {
        case NSURLErrorDomain:
            return .network(nsError)
        default:
            return .unknown(error)
        }
    }
    
    static func wrap<T>(_ completion: @escaping (T?, LCPError?) -> Void) -> (T?, Error?) -> Void {
        return { value, error in
            if let error = error {
                completion(value, LCPError.wrap(error))
            } else {
                completion(value, nil)
            }
        }
    }
    
}