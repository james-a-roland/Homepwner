//
//  ItemStore.swift
//  Homepwner
//
//  Created by James Roland on 9/15/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class ItemStore: NSObject {
    var allItems: [Item] = []
    
    func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        return newItem
    }
    
    func removeItem(item: Item) {
        if let index = find(allItems, item) {
            allItems.removeAtIndex(index)
        }
    }
    
    func moveItemAtIndex(fromIndex: Int, toIndex: Int) {
        if fromIndex == toIndex {
            return
        }
        
        let movedItem = allItems[fromIndex]
        allItems.removeAtIndex(fromIndex)
        allItems.insert(movedItem, atIndex: toIndex)
    }
}


