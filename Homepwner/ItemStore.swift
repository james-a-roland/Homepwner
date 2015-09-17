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
    
    let itemArchiveURL: NSURL = {
        let documentsDirectories =
        NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        //UserDomainMask is always used for iOS in particular.
        let documentDirectory = documentsDirectories.first as! NSURL
        return documentDirectory.URLByAppendingPathComponent("items.archive")
    }()
    
    override init() {
        super.init()
        let nc = NSNotificationCenter.defaultCenter()
        
        if let archivedItems = NSKeyedUnarchiver.unarchiveObjectWithFile(itemArchiveURL.path!) as? [Item] {
            allItems += archivedItems
        }
        
        nc.addObserver(self, selector: "appDidEnterBackground:", name: UIApplicationDidEnterBackgroundNotification, object: nil)
    }
    
    func createItem() -> Item {
        let newItem = Item(random: false)
        allItems.append(newItem)
        return newItem
    }
    
    func addItem(item: Item) {
        allItems.append(item)
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
    
    func saveChanges() -> Bool {
        println("Saving items to: \(itemArchiveURL.path!)")
        return NSKeyedArchiver.archiveRootObject(allItems, toFile: itemArchiveURL.path!)
    }
    
    func appDidEnterBackground(note: NSNotification) {
        let success = saveChanges()
        if success {
            println("=====\nSaved items")
        }
        else {
            println("=====\nCould not save the items")
        }
    }
}


