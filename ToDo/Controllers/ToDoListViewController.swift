//
//  ViewController.swift
//  ToDo
//
//  Created by Praveen Singh on 19/03/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController{

    var itemArray = [Item]()
    
    // optional categryß
    var selectedCategory : Category? {
        didSet {
            // Retrieve the data from our context - in crore data
            // already got a value for category
            loadItems()
        }
    }

    
    // singleton shared ui application object from the app delegate and then tap into persistant container property
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // file path where our current data is stored
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        
        
        

        
    }

    //MARK - Tableview Datasource methods
    
    // Number of rows to be displayed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    //What to display in the rows/cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        // Ternary operator
        // value = condition ? vaueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done ? .checkmark : .none
        
        
        return cell
        
    }
    
    //MARK - TableView delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       //  print(indexPath.row)
        // print(itemArray[indexPath.row])
        
        // removing data from temp storage
        // context.delete(itemArray[indexPath.row])
        
        //removing current selected item from database
        // itemArray.remove(at: indexPath.row)
        

         itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //empty text field - global var
        
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in

            
            // creating newItem object from Item class in Core Data model
            
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem)
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        
        
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }


}
    //MAARK - Model Manipulation Methods
    func saveItems() {
        // uSing core dat a to save data
        
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        
        self.tableView.reloadData() //refersh the table view
    }
    
    // Load items from the core data
    // request everything in Item data model/class through our context
    // with is an external parameter and request is an internal parameter
    // default value if no parameter - Item.fetchrequest() - load everything in database
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
      
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        // optional binding
        if let addionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, addionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
//
//}

}

//MARK: - search bar methods
extension ToDoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // read from context
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // what is the filter/query - what we want to get from database
        // by default contains is case and diacratic sensitive, so we make it insensitive by adding cd and add query to request
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@ ", searchBar.text!)
        

        
        // sort retrieved data
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(with: request, predicate: predicate) // here request is an external parameter to function
        
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
