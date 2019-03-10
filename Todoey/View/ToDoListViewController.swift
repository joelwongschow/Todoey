//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Schow on 3/5/19.
//  Copyright © 2019 Joel Schow. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogrogon"]
    var itemArray = [Item]()
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    //let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        print(dataFilePath!)
        
        let item1 = Item()
        item1.title = "Do Step 1"
        //item1.done = true
        itemArray.append(item1)
        
        do{
            if let data = try? Data(contentsOf: dataFilePath!) {
                let decoder = PropertyListDecoder()
                itemArray = try decoder.decode([Item].self, from: data)
            }
        } catch {
            print("error fetching data")
        }
        
       // if let items = defaults.object(forKey: "TodoListArray") as? [Item] {
       //     itemArray = items
        //}
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        if itemArray[indexPath.row].done {
            cell.accessoryType = .checkmark
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        /*if itemArray[indexPath.row].done {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }*/
        
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
                let tempItem = Item()
                tempItem.title = tempText
                self.itemArray.append(tempItem)
                self.addNewestItemToTableView()
                
                self.saveItems()
                //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            }
        }
        
        alert.addAction(action)
    
        present(alert, animated: true,completion: nil)
    }
    
    func addNewestItemToTableView(){
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: itemArray.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
    func saveItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        } catch {
            print("error encoding item array")
        }
    }
    
}

