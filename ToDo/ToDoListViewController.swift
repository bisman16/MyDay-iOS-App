//
//  ViewController.swift
//  ToDo
//
//  Created by Praveen Singh on 19/03/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["One", "Two", "Three"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Retrieve the data from the deafults settings instance of user
        if let items = defaults.array(forKey: "toDoListArray") as? [String] {
            itemArray = items
        }
        
    }

    //MARK - Tableview Datasource methods
    
    // Number of rows to be displayed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //What to display in the rows/cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //  print(indexPath.row)
        // print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //empty text field - global var
        
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Action", style: .default) { (action) in
            self.itemArray.append(textField.text!)
            
            // Passing key value pair to the defaults instance
            self.defaults.set(self.itemArray, forKey: "toDoListArray")
            
            self.tableView.reloadData() //refersh the table view
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
}

