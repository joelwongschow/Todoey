//
//  Category.swift
//  Todoey
//
//  Created by Joel Schow on 3/13/19.
//  Copyright © 2019 Joel Schow. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    let items = List<Item>()
}
