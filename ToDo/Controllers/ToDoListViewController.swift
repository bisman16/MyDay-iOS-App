//
//  ViewController.swift
//  ToDo
//
//  Created by Praveen Singh on 19/03/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController{
    
    
    // results container
    var todoItems: Results<Item>?
    
    let realm = try! Realm()
    
    // optional category
    var selectedCategory : Category? {
        didSet {
            // Retrieve the data from our context - in crore data
            // already got a value for category
            loadItems()
        }
    }

    


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // file path where our current data is stored
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
    }

    //MARK - Tableview Datasource methods
    
    // Number of rows to be displayed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    //What to display in the rows/cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // if it is not nill, change accessories
        if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
            
            // Ternary operator
            // value = condition ? vaueIfTrue : valueIfFalse
            
            cell.accessoryType = item.done ? .checkmark : .none
        } else { // if it fails
            cell.textLabel?.text = "No items addedß"
        }
        
        
        
        
        return cell
        
    }
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // updating data
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error saving done status \(error)")
            }
        }
        
        tableView.reloadData()
        

        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //empty text field - global var
        
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            
            // creating newItem object from Item class in Core Data model
            
            // unwrap selectedCategory as it is an optional
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items \(error)")
                }
            }
            
                self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }


    
    //MAARK - Model Manipulation Methods

    
    // Load items from the core data
    // request everything in Item data model/class through our context
    // with is an external parameter and request is an internal parameter
    // default value if no parameter - Item.fetchrequest() - load everything in database
    
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)


        tableView.reloadData()
    }
//
//}
}


// MARK: - search bar methods
    
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // filter our todoItems list and update it by the predicate
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        
        tableView.reloadData()
        
        
    }

    

    // new method to get back to original list once the user closes the seach query
    // text change and gone down to zero
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems() // will load default item array

            // we want the keyboard to go back to its orginal postion after search query is closed, no longer cursor etc., go back to original interface
            // we have to tap into and affect the main thread despite processes running in background
            // assign projects into different threads

            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }

        }
    }



}


