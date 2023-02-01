//
//  DateExtension.swift
//  Journal - CloudKit
//
//  Created by Dominique Strachan on 1/31/23.
//

import Foundation

extension Date {
    
    func formatDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        
        return formatter.string(from: self)
    }
}
