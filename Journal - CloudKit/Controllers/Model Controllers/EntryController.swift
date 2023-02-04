//
//  EntryController.swift
//  Journal - CloudKit
//
//  Created by Dominique Strachan on 1/31/23.
//

import Foundation
import CloudKit

class EntryController {
    
    //shared instance/singleton
    static let shared = EntryController()
    
    //source of truth
    var entries: [Entry] = []
    
    //MARK: - Properties
    let privateDB = CKContainer.default().privateCloudDatabase
    
    //CRUD
    func createEntry(title: String, text: String, completion: @escaping(_ result: Result<Entry?, EntryError>) -> Void) {
        
        //new instance of/initializing a new entry with its parameters
        let newEntry = Entry(title: title, text: text)
        
        saveEntry(entry: newEntry, completion: completion)

    }
    
    
    func saveEntry(entry: Entry, completion: @escaping (_ result: Result<Entry?, EntryError>) -> Void) {
        
        //initializing entry record from passed in entry from parameter
        let entryRecord = CKRecord(entry: entry)
        
        //calling on save method from private database
        privateDB.save(entryRecord) { record, error in
            //handling optional error
            if let error = error {
                completion(.failure(.ckError(error)))
                return
            }
            
            //unwrapping CKRecord that was saved
            guard let record = record,
                  //recreating the same entry object for saved record
                  let savedEntry = Entry(ckRecord: record)
            else { completion(.failure(.unableToUnwrap)); return }
            print("Saved entry successfully")
            
            //adding entry to local source of truth
            self.entries.insert(savedEntry, at: 0)
            //completion success with new saved entry object
            completion(.success(savedEntry))
        }
        
    }
    
    //fetching all the entries stored in private database
    func fetchEntries(completion: @escaping(_ result: Result<[Entry]?, EntryError>) -> Void) {
        
        //NSPredicate is a definition of logical conditions (true-false) used to constrain a search either for a fetch or for in-memory filtering. For this project, we want to get all entries back from the private database so we will be using the initializer that takes in a value, and we will be setting that value to true This tells the predicate to just return everything
        //predicate needed for parameters for query
        let predicate = NSPredicate(value: true)
        
        //creating query for private database
        //A CKQuery takes in two parameters, recordType: String and predicate: NSPredicate The recordType will be a string representation of our CKRecord. You can call this string off of the static property in your Constants struct
        //query needed for the perform(query) method
        let query = CKQuery(recordType: EntryStrings.recordTypeKey, predicate: predicate)
        
        //.fetch() ???? used to replace .perform - deprecated
        //.perform - Searches for records matching a predicate in the specified record zone.
        
        
        privateDB.fetch(withQuery: query) { result in
            switch result {
            case .success(let result):
                result.matchResults.compactMap{ $0.1 }
                    .forEach{
                        switch $0 {
                        case .success(let record):
                            guard let entry = Entry(ckRecord: record) else {
                                completion(.failure(.unableToUnwrap))
                                return
                             }
                            self.entries.append(entry)
                        case.failure:
                            completion(.failure(.unableToUnwrap))
                        }
                    }
                
                completion(.success(self.entries))
         
//                //unwrapping successfully fetched records
//                guard let records = records else { completion(.failure(.unableToUnwrap)); return }
//                print("Successfully fetched all entries")
//
//                //filtering through entries in records that are non-nil
//                let entries = records.compactMap ({ Entry(ckRecord: $0) })
//
//                //setting filtered entries to source of truth
//                self.entries = entries
//
//                //@escaping complete with array of entry objects
//                completion(.success(entries))
        
            case .failure(let error):
                completion(.failure(.ckError(error)))
            }
        }
        
//        privateDB.perform(query, inZoneWith: nil) { records, error in
//
//            //handling optional error
//            if let error = error {
//                completion(.failure(.ckError(error)))
//            }
//
//            //unwrapping successfully fetched records
//            guard let records = records else { completion(.failure(.unableToUnwrap)); return }
//            print("Successfully fetched all entries")
//
//            //filtering through entries in records that are non-nil
//            let entries = records.compactMap ({ Entry(ckRecord: $0) })
//
//            //setting filtered entries to source of truth
//            self.entries = entries
//
//            //@escaping complete with array of entry objects
//            completion(.success(entries))
//        }
        
        //pagination - fetch in batches not everything all at once - fetches pages then will fetch more data when clicking or scrolling to next page/section
            //hit ~20 results then spinner to load next ~20 results
            //query cursor
        
    }
    
}//end of class
