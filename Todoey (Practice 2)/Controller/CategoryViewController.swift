//
//  CategoryViewController.swift
//  Todoey (Practice 2)
//
//  Created by Michael Handkins on 9/7/20.
//  Copyright © 2020 Michael Handkins. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UITableViewController {
    
    let categories = [Category]()
    
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    //MARK: - Table View Data Sources
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories.count
    }


    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)

        return cell
        
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
                
            }
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (actionKeyboard) in
            actionKeyboard.placeholder = "Type category list title here..."
            keyboard = actionKeyboard
        }
        
    }
    

}
