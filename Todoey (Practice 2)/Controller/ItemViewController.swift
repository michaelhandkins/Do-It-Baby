//
//  ItemViewController.swift
//  Todoey (Practice 2)
//
//  Created by Michael Handkins on 9/7/20.
//  Copyright © 2020 Michael Handkins. All rights reserved.
//

import UIKit
import RealmSwift

class ItemViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var currentCatgory: Category?
    
    var items: Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }
    
    //MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

        cell.textLabel?.text = items?[indexPath.row].name ?? "Add Todo Items Using The '+'"
        
        if let itemList = items {
            cell.accessoryType = itemList[indexPath.row].done ? .checkmark : .none
        }

        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var keyboard = UITextField()
        
        let alert = UIAlertController(title: "Create Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todo", style: .default) { (action) in
            
            if let todoName = keyboard.text {
                let newTodo = Item()
                newTodo.name = todoName
                
                do {
                    try self.realm.write {
                        self.realm.add(newTodo)
                        self.currentCatgory?.children.append(newTodo)
                    }
                } catch {
                    print("Error thrown when attempting to add new todo item to Realm: \(error)")
                }
                
                self.tableView.reloadData()
                
            } else {
                print("No text was entered in order to create a todo")
            }
        }
        
        alert.addAction(action)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Write your todo item here..."
            keyboard = alertTextField
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadItems() {
        items = currentCatgory?.children.sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let itemList = items {
            do {
                try realm.write {
                    itemList[indexPath.row].done = !itemList[indexPath.row].done
                }
                loadItems()
            } catch {
                print("Error when selecting todo item to update its done status: \(error)")
            }
            
        }
        
    }
    
    
    

}
