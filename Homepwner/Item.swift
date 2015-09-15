//
//  Item.swift
//  Homepwner
//
//  Created by James Roland on 9/15/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class Item: NSObject {
    var name: String
    var valueInDollars: Int
    var serialNumber: String?
    let dateCreated: NSDate
    
    init(name: String, serialNumber: String?, valueInDollars: Int) {
        self.name = name
        self.valueInDollars = valueInDollars
        self.serialNumber = serialNumber
        self.dateCreated = NSDate()
        super.init()
    }
}
