//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Schow on 3/5/19.
//  Copyright © 2019 Joel Schow. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController, UISearchBarDelegate {

    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogrogon"]
    var itemArray = [Item]()
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    var requestForCurrentCategory : NSFetchRequest<Item> = Item.fetchRequest()
    
    var selectedCategory : Category? {
        didSet {
            //let requestForCurrentCategory : NSFetchRequest<Item> = Item.fetchRequest()
            requestForCurrentCategory.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            loadItems(request: requestForCurrentCategory)
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // loadItems()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.cellForRow(at: indexPath)?.accessoryType = itemArray[indexPath.row].done ? .none : .checkmark
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let tempText = alert.textFields?[0].text {
                let tempItem = Item(context: self.context)
                tempItem.title = tempText
                tempItem.done = false
                tempItem.parentCategory = self.selectedCategory
                self.itemArray.append(tempItem)
                //self.addNewestItemToTableView()
                self.tableView.reloadData()
                
                self.saveItems()
                
                //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            }
        }
        
        alert.addAction(action)
    
        present(alert, animated: true,completion: nil)
    }
    
//    func addNewestItemToTableView(){
//        tableView.beginUpdates()
//        tableView.insertRows(at: [IndexPath(row: itemArray.count - 1, section: 0)], with: .automatic)
//        tableView.endUpdates()
//    }
    
    func saveItems() {
        do {
            try context.save()
        } catch {
            print("error saving items to context")
        }
    }
    
    func loadItems(request : NSFetchRequest<Item> = Item.fetchRequest()) {
        do {
            itemArray = try context.fetch(request)
        } catch {
            print("Error fetching data")
        }
        tableView.reloadData()
        
       // print(itemArray.count)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        let predicateForTitle = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)   
        let predicateForCategory = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateForTitle, predicateForCategory])
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadItems(request: request)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems(request: requestForCurrentCategory)
        DispatchQueue.main.async {
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems(request: requestForCurrentCategory)
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

