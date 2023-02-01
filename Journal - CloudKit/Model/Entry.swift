//
//  Entry.swift
//  Journal - CloudKit
//
//  Created by Dominique Strachan on 1/31/23.
//

import Foundation
import CloudKit

//constants
//strings for setting CKrecord values
struct EntryStrings {
    
    //can use private if create Entry extension
    static let recordTypeKey = "Entry"
    fileprivate static let timestampKey = "timestamp"
    fileprivate static let titleKey = "title"
    fileprivate static let textKey = "key"
}

class Entry {
    
    let ckRecordID: CKRecord.ID
    var timestamp: Date
    var title: String
    var text: String
    
    //memberwise initializer for entry model
    //default values for CKRecord.ID and timestamp
    init(CKRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString),timestamp: Date = Date(), title: String, text: String) {

        //initializing stored properties with its datatype or default value
        self.ckRecordID = CKRecordID
        self.timestamp = timestamp
        self.title = title
        self.text = text
    }
    
    /*
     //variable declaration for entry properties in CKRecord
    var cloudKitRecord: CKRecord {
        //recordID
        let record = CKRecord(recordType: Entry.recordTypeKey)

        record.setValue(timestamp, forKey: timestampKey)
        record.setValue(title, forKey: titleKey)
        record.setValue(text, forKey: textKey)

        return record
    }
    
     //convenience initializer to create a CKRecord from an Entry object
    init?(cloudKitRecord: CKRecord) {
     //record properties
        guard let timestamp = cloudKitRecord[Entry.TimeStampKey] as? Date,
              let title = cloudKitRecord[Entry.TitleKey] as? String,
              let text = cloudKitRecord[Entry.TextKey] as? String else { return nil }
        
        self.timestamp = timestamp
        self.title = title
        self.text = text
    }
    */
    
    
    //combining initializer and variable declaration/properties
    //taking ckRecord and pulling out the values found to initialize hype model
    //NOTE: CKrecord can only have certain data types
    convenience init?(ckRecord: CKRecord) {
        //casting
        //timestamp = "timestamp" : Date
        guard let timestamp = ckRecord[EntryStrings.timestampKey] as? Date,
              //casting
              //title = "title" : String
              let title = ckRecord[EntryStrings.titleKey] as? String,
              //casting
              //text = "text" : String
              let text = ckRecord[EntryStrings.textKey] as? String else { return nil }

        //required entry properties to be stored in ckRecord
        self.init(timestamp: timestamp, title: title, text: text)
        
    }
    
}

//initializing instance of CKrecord with key/value pairs must be written in CKRecord extension
extension CKRecord {

    //packaging entry model properties to be stored in CKRecord and saved to the cloud
    ////entry variable in parameter is Entry class
    convenience init(entry: Entry) {
        //naming record
        self.init(recordType: EntryStrings.recordTypeKey, recordID: entry.ckRecordID)

        //finalizing record fields/keys with variable/datatype
        self.setValuesForKeys([
            //"timestamp" : timestamp/Date
            EntryStrings.timestampKey : entry.timestamp,
            //"title" : title/string
            EntryStrings.titleKey : entry.title,
            //"text" : text/string
            EntryStrings.textKey : entry.text
        ])
    }
}
