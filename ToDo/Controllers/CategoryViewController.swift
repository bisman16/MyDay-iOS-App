//
//  CategoryViewController.swift
//  ToDo
//
//  Created by Praveen Singh on 29/03/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//
// pod 'SwipeCellKit', :git => 'https://github.com/SwipeCellKit/SwipeCellKit.git', :branch => 'swift_4.2'
import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    // used try! because Realm can throw errors at the start of app because of resource constraints
    let realm = try! Realm()
    
    // Creating an empty instance/object/object of Category class/table so that we can edit the array of rows
    // results object after querying from realm database
    // results is a data type - auto update container
    // ! - forced unwrapped (telling it that it definitely has a value, will throw error if no value - not safe to use sometimes), so use ? - optional
    
    
    // collection of results that are category objects
    var categories: Results<Category>?
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
      loadCategories()
       
    }

   
    //MARK: - TableView Datasource Methods
    
    // Number of rows to be displayed
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return categories and if nill, return 1 cell
        return categories?.count ?? 1
    }
    
    // Content to be displayed in rows/cells
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create a reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        

        
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No categories added yet"
        
        return cell
        
    }
    
     //MARK: - TableView Delegate Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    
    
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving category \(error)")
        }
        
        self.tableView.reloadData()
        
    }
    
    // to load all categories at the start of app
    func loadCategories() {

        // pull out everything in Category object
        categories = realm.objects(Category.self)
        
        
        // reloadData() calls all the data source methods
        tableView.reloadData()

    }
//
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // alert box with a title
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        // action button, handler -> what to do when the user hit the 'Add category' button -> make a closure
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
         
        // Creating new object/row/entry in category class/table
        let newCategory = Category()
        
        newCategory.name = textField.text!
            
        
            self.save(category: newCategory)
            
            
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
