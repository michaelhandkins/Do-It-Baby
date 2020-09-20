//
//  CategoryViewController.swift
//  Todoey (Practice 2)
//
//  Created by Michael Handkins on 9/7/20.
//  Copyright © 2020 Michael Handkins. All rights reserved.
//

import UIKit
import RealmSwift
import SwipeCellKit
import ChameleonFramework

class CategoryViewController: UITableViewController {
    
    var categories: Results<Category>?
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 100
        
        self.navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "Lobster-Regular", size: 42)!]
        
        if let navabarColor = self.navigationController?.navigationBar.backgroundColor {
            
            self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : ContrastColorOf(navabarColor, returnFlat: true)]
            self.navigationController?.navigationBar.tintColor = ContrastColorOf(navabarColor, returnFlat: true)
            
        }
        
        loadCategories()
    }

    //MARK: - Table View Data Sources
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        var keyboard = UITextField()
        
        let alert = UIAlertController(title: "Create List Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Create List", style: .default) { (action) in
            
            if let keyboardText = keyboard.text {
                
                let newCategory = Category()
                newCategory.name = keyboardText
                
                do {
                    try self.realm.write {
                        self.realm.add(newCategory)
                    }
                } catch {
                    print("Error while adding new Category to realm: \(error)")
                }
                
                self.loadCategories()
                
            }
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (actionKeyboard) in
            actionKeyboard.placeholder = "Type category list title here..."
            keyboard = actionKeyboard
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func loadCategories() {
        
        categories = realm.objects(Category.self)
        
        tableView.reloadData()
        
    }
    
    //MARK: - Segue
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toItemsSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! ItemViewController
        
        if let selectedCategory = tableView.indexPathForSelectedRow {
            destination.currentCatgory = categories?[selectedCategory.row]
        }
    }
    

}

extension CategoryViewController: SwipeTableViewCellDelegate {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! SwipeTableViewCell
        
        cell.delegate = self

        cell.textLabel?.text = categories?[indexPath.row].name ?? "Create A Todo List Using The '+'"
        
        if let cellColor = UIColor(hexString: categories![indexPath.row].color) {
            cell.backgroundColor = cellColor
        }
        
        cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)

        return cell
       }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        if let categoryList = categories {
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                
                do {
                    try self.realm.write {
                        self.realm.delete(categoryList[indexPath.row])
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
