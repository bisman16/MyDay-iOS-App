//
//  ViewController.swift
//  ToDo
//
//  Created by Praveen Singh on 19/03/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Creating file path to the document folder and creating own plist
        
        
        print(dataFilePath)

        
        
        // Retrieve the data from our custom plist - calling the method
        loadItems()
        
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
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        saveItems()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField() //empty text field - global var
        
        let alert = UIAlertController(title: "Add new ToDo item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Action", style: .default) { (action) in
            
            let newItem = Item()
            newItem.title = textField.text!
            
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
        // Encoding our data into a property list and writing data to it
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error encoding itema array, \(error)")
        }
        
        self.tableView.reloadData() //refersh the table view
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
            itemArray = try decoder.decode([Item].self, from: data)
            } catch {
                print("Error decoding itemArray \(error)")
            }
    }

}

}
