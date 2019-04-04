//
//  Category.swift
//  ToDo
//
//  Created by Praveen Singh on 03/04/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    //forward relation
    //Category object has items which is list/array of type - <Item> - empty initially
    // each category has one-to-many relationship with items
    let items = List<Item>()
}
