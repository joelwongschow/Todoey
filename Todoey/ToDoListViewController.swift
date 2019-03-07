//
//  ViewController.swift
//  Todoey
//
//  Created by Joel Schow on 3/5/19.
//  Copyright © 2019 Joel Schow. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogrogon"]
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(itemArray[indexPath.row])
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Create New Item"
        }
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append((alert.textFields?[0].text)!)
            self.addNewestItemToTableView()
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
        }
        
        alert.addAction(action)
    
        present(alert, animated: true,completion: nil)
    }
    
    func addNewestItemToTableView(){
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: itemArray.count - 1, section: 0)], with: .automatic)
        tableView.endUpdates()
    }
    
}

