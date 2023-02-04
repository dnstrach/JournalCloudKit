//
//  EntryListTableViewController.swift
//  Journal - CloudKit
//
//  Created by Dominique Strachan on 1/31/23.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        EntryController.shared.fetchEntries { result in
            //self.tableView.reloadData()
            
            //table view reloads after fetching entries/result
            self.updateViews()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //reloads rows and sections
        tableView.reloadData()
    }
    
    //reloading table view to show saved entry in table view list
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    //MARK: - Class Methods
    func updateViews() {
        //reloads on main thread
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return EntryController.shared.entries.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)

        //placing each entry in entries array in individual cells
        let entry = EntryController.shared.entries[indexPath.row]
        
        //UIListContentConfiguration?
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestamp.formatDate()

        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //identifier
        if segue.identifier == "toEditEntry" {
            //index path
            guard let indexPath = tableView.indexPathForSelectedRow,
                  //destination
                  let destinationVC = segue.destination as? EntryDetailViewController else { return }
            
            //object being passed over from selected cell
            let entryToSend = EntryController.shared.entries[indexPath.row]
            //receiver
            destinationVC.entry = entryToSend
        }
    }

}
