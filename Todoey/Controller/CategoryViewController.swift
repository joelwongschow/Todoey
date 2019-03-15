//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Joel Schow on 3/12/19.
//  Copyright © 2019 Joel Schow. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    var categories : Results<Category>!
    
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
                let tempCategory = Category()
                tempCategory.name = tempText
                
                self.saveCategory(category: tempCategory)
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
            destinationVC.selectedCategory = categories[indexPath]
            //print("i get INSIDE if statement SECOND")
        }
    }
    
    // MARK: - Tableview Datasource Methods

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //print(categories?.count)
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet!"

        //print("got here \(categories?.count)")
        
        if categories?.count == 0 {
            cell.textLabel?.text = "No Categories Added Yet!"
        } else {
            cell.textLabel?.text = categories?[indexPath.row].name
        }
        
        return cell
    }
    
    // MARK: - Tableview Data Manipulation Methods
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    func saveCategory(category: Category) {
        do{
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("error adding category")
        }
            
    }
    
    
}
