//
//  ItemViewController.swift
//  Todoey (Practice 2)
//
//  Created by Michael Handkins on 9/7/20.
//  Copyright © 2020 Michael Handkins. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class ItemViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var currentCatgory: Category?
    
    var items: Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        loadItems()
        self.title = currentCatgory?.name
        
        if let categoryColor = UIColor(hexString: currentCatgory!.color) {
            
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(categoryColor, returnFlat: true)]
            self.navigationController?.navigationBar.tintColor = ContrastColorOf(categoryColor, returnFlat: true)
            self.navigationController?.navigationBar.backgroundColor = categoryColor
            
        }
        
    }
    
    //MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 0
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

extension ItemViewController: SwipeTableViewCellDelegate {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self

        cell.textLabel?.text = items?[indexPath.row].name ?? "Add Todo Items Using The '+'"
        
        let categoryColor = UIColor(hexString: self.currentCatgory!.color)
        if let color = categoryColor?.darken(byPercentage: CGFloat(indexPath.row) / CGFloat(items!.count)) {
            cell.backgroundColor = color
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            cell.tintColor = ContrastColorOf(color, returnFlat: true)
        }
        
        if let itemList = items {
            cell.accessoryType = itemList[indexPath.row].done ? .checkmark : .none
        }

        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        if let itemList = items {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                do {
                    try self.realm.write {
                        self.realm.delete(itemList[indexPath.row])
                    }
                } catch {
                    print("Error when trying to delete item from realm via SwipeCellKit: \(error)")
                }
            }

            // customize the action appearance
            deleteAction.image = UIImage(named: "delete")

            return [deleteAction]
            
        } else {
            return nil
        }

        
        
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
    
    
}
