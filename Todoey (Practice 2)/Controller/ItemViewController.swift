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
    
    var currentCatgory: Category?
    
    var items: Results<Item>?

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Table View Data Source Methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return items?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)

        cell.textLabel?.text = items?[indexPath.row].name ?? "Add Todo Items Using The '+'"

        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var keyboard = UITextField()
        
        let alert = UIAlertController(title: "Create Todo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todo", style: .default) { (action) in
            
            if let todoName = keyboard.text {
                let newTodo = Item()
                newTodo.name = todoName
                self.currentCatgory?.children.append(newTodo)
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
    

}
