//
//  EntryDetailViewController.swift
//  Journal - CloudKit
//
//  Created by Dominique Strachan on 1/31/23.
//

import UIKit

class EntryDetailViewController: UIViewController {

    //landing pad
    var entry: Entry? {
        //did set monitors changes in entry object -- if changes are made dispatch queue updates on main thread
        didSet {
            //loadViewIfNeeded()
            DispatchQueue.main.async {
                self.loadViewIfNeeded()
                self.updateViews()
            }
        }
    }
    
    //MARK: Outlets
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textFieldBody: UITextView!
    
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
        
        //assigning entry detail VC to be delegate for title text field
        titleTextField.delegate = self
    }
    
    //MARK: Helper Methods
    func updateViews() {
        //checking if the optional entry property holds an entry
        guard let entry = entry else { return }
        //updating view elements that reflect details about the model object entry
        titleTextField.text = entry.title
        textFieldBody.text = entry.text
    }
    
    //MARK: - Actions
    @IBAction func mainViewTapped(_ sender: Any) {
        //allows the user to dismiss the keyboard by touching anywhere on the outer screen
        titleTextField.resignFirstResponder()
        textFieldBody.resignFirstResponder()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
              let text = textFieldBody.text else { return }
        
        EntryController.shared.createEntry(title: title, text: text) { result in
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
        titleTextField.text = ""
        textFieldBody.text = ""
    }
} // end of class

extension EntryDetailViewController : UITextFieldDelegate {
    
    //delegate function
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //resign first responder to dismiss the keyboard
        titleTextField.resignFirstResponder()
        return true
    }
}
