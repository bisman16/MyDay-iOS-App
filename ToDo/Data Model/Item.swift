//
//  Item.swift
//  ToDo
//
//  Created by Praveen Singh on 03/04/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//

import Foundation
import  RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    //Inverse relation  - each item has an inverse relation to a category - parent category
    // each item has a parent category of type category and comes from propoerty called items
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    
}
