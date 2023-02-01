//
//  EntryError.swift
//  Journal - CloudKit
//
//  Created by Dominique Strachan on 1/31/23.
//

import Foundation

enum EntryError: Error, LocalizedError {
    
    case ckError(Error)
    case unableToUnwrap
    
    var errorDescription: String? {
        switch self {
        case .ckError(let error):
            return "Error in \(#function) : \(error.localizedDescription) \n--\n \(error)"
        case .unableToUnwrap:
            return "unable to save/unwrap entry"
        }
    }

}
