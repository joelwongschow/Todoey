//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Schow on 3/5/19.
//  Copyright © 2019 Joel Schow. All rights reserved.
//

import UIKit
import RealmSwift

class ToDoListViewController: UITableViewController, UISearchBarDelegate {

    let realm = try! Realm()
    
    var toDoItems : Results<Item>!
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //var requestForCurrentCategory : NSFetchRequest<Item> = Item.fetchRequest()
    
    var selectedCategory : Category? {
        didSet {
            //let requestForCurrentCategory : NSFetchRequest<Item> = Item.fetchRequest()
           // requestForCurrentCategory.predicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
            //let predicate = NSPredicate(format: "parentCategory.name MATCHES ", <#T##args: CVarArg...##CVarArg#>)
            loadItems()
        }
    }
    
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
       // loadItems()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        if let tempItem = toDoItems?[indexPath.row] {
            cell.textLabel?.text = tempItem.title
            cell.accessoryType = tempItem.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added Yet!"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if toDoItems != nil {
            //tableView.cellForRow(at: indexPath)?.accessoryType = toDoItems[indexPath.row].done ? .none : .checkmark
            do {
                try self.realm.write {
                    self.toDoItems[indexPath.row].done = !self.toDoItems[indexPath.row].done
                }
            } catch {
                print("error saving item to category array")
            }
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let tempText = alert.textFields?[0].text {
                
                if self.selectedCategory != nil {
                    do {
                        try self.realm.write {
                            let tempItem = Item()
                            tempItem.title = tempText
                            tempItem.done = false
                            self.selectedCategory?.items.append(tempItem)
                        }
                    } catch {
                        print("error saving item to category array")
                    }
                }
                
                //self.saveItems(itemToAdd: tempItem)
                self.tableView.reloadData()
                
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
    
    func saveItems(itemToAdd: Item) {
        do {
            try realm.write {
                realm.add(itemToAdd)
            }
        } catch {
            print("Error saving items")
        }
    }
    
    func loadItems() {
        toDoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoItems = toDoItems.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "title", ascending: true)
        
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        let predicateForTitle = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//        let predicateForCategory = NSPredicate(format: "parentCategory.name MATCHES %@", (selectedCategory?.name)!)
//        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicateForTitle, predicateForCategory])
//
//        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
//
//        loadItems(request: request)
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        loadItems()
        DispatchQueue.main.async {
            searchBar.text = ""
            searchBar.resignFirstResponder()
        }
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}

