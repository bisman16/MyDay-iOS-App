//
//  Data.swift
//  ToDo
//
//  Created by Praveen Singh on 02/04/19.
//  Copyright © 2019 Bisman Singh. All rights reserved.
//

import Foundation
import RealmSwift

//Object is a super class in Realm
class Data: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
