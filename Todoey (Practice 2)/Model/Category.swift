//
//  Category.swift
//  Todoey (Practice 2)
//
//  Created by Michael Handkins on 9/8/20.
//  Copyright © 2020 Michael Handkins. All rights reserved.
//

import Foundation
import RealmSwift
import ChameleonFramework

class Category: Object {
    @objc dynamic var name: String = ""
    let color: UIColor = FlatSkyBlue()

    let children = List<Item>()
}
