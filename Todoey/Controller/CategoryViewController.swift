//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joel Schow on 3/12/19.
//  Copyright © 2019 Joel Schow. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    var categoryArray = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }

    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add a New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter New Category Here"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { (action) in
            if let tempText = alert.textFields?[0].text {
                let tempCategory = Category(context: self.context)
                tempCategory.name = tempText
                
                self.categoryArray.append(tempCategory)
                self.saveCategories()
                self.tableView.reloadData()
            }
        }
        
        alert.addAction(addAction)
        present(alert, animated: true)
    }
    
    // MARK: - Tableview Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ToDoListViewController
        //print("i am BEFORE if statement")
        //print(tableView.indexPathForSelectedRow?.row)
        if let indexPath = tableView.indexPathForSelectedRow?.row {
            //print("i get INSIDE if statement FIRST")
            destinationVC.selectedCategory = categoryArray[indexPath]
            //print("i get INSIDE if statement SECOND")
        }
    }
    
    // MARK: - Tableview Datasource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        
        return cell
    }
    
    // MARK: - Tableview Data Manipulation Methods
    
    func loadCategories(request: NSFetchRequest<Category> = Category.fetchRequest()) {
        do {
            categoryArray = try context.fetch(request)
        } catch {
            print("error fetching category data")
        }
        
        tableView.reloadData()
    }
    
    func saveCategories() {
        do {
            try context.save()
        } catch {
            print("error fetching category data")
        }
    }
    
    
}
