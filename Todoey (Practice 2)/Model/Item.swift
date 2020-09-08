//
//  Item.swift
//  Todoey (Practice 2)
//
//  Created by Michael Handkins on 9/8/20.
//  Copyright © 2020 Michael Handkins. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date = Date()
    var parent = LinkingObjects(fromType: Category.self, property: "children")
}
