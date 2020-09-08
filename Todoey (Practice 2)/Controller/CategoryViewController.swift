//
//  CategoryViewController.swift
//  Todoey (Practice 2)
//
//  Created by Michael Handkins on 9/7/20.
//  Copyright © 2020 Michael Handkins. All rights reserved.
//

import UIKit

class CategoryViewController: UITableViewController {
    
    let categories = [String]()

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
            
            
        }
        
        alert.addAction(action)
        
        alert.addTextField { (actionKeyboard) in
            actionKeyboard.placeholder = "Type category list title here..."
            keyboard = actionKeyboard
        }
        
    }
    

}
