//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Praveen Singh on 29/03/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    // Creating an empty instance/object/object of Category class/table so that we can edit the array of rows
    var categoryArray = [Category]()
    
    // Creating a context instance through ui application delegate to access the permanent database - Persistant container through its contet property, shared- singleton
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
       
    }

   
    //MARK: - TableView Datasource Methods
    
    // Number of rows to be displayed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    // Content to be displayed in rows
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        let category = categoryArray[indexPath.row]
        
        cell.textLabel?.text = category.name
        
        return cell
        
    }
    
     //MARK: - TableView Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    func saveCategories() {
        
        do {
            try context.save()
        }
        catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    // to load all categories at the start of app
    func loadCategories() {
        
        // read data from context - specify a request
        let request : NSFetchRequest<Category> = Category.fetchRequest() // grab all objects created using Category class
       
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error loading categories \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // alert box with a title
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        // action button, handler -> what to do when the user hit the 'Add category' button -> make a closure
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
         
        // Creating new object/row/entry in category class/table
        let newCategory = Category(context: self.context)
        
            newCategory.name = textField.text!
            
        self.categoryArray.append(newCategory)
        
        self.saveCategories()
            
            
        }
        
        alert.addAction(action)
        
        // text field created and added to alert
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
            
        }
        
        // present the alert
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
   
    
    
    
    
    
    
}
