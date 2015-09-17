//
//  ItemsViewController.swift
//  Homepwner
//
//  Created by James Roland on 9/15/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class ItemsViewController: UITableViewController, UITableViewDataSource {
    
    let itemStore: ItemStore
    let imageStore: ImageStore
    
    init(itemStore: ItemStore, imageStore: ImageStore) {
        self.itemStore = itemStore
        self.imageStore = imageStore
        super.init(nibName: nil, bundle: nil)
        
        let addItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addNewItem:")
        navigationItem.rightBarButtonItem = addItem
        navigationItem.leftBarButtonItem = editButtonItem()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ItemCell")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addNewItem(sender: AnyObject) {
        let newItem = Item(random: false)
        let dvc = DetailViewController(item: newItem, imageStore: imageStore)
        dvc.isNew = true
        
        dvc.cancelClosure = {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        dvc.saveClosure = {
            self.itemStore.addItem(newItem)
            if let index = find(self.itemStore.allItems, newItem) {
                let indexPath = NSIndexPath(forRow: index, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        let nc = UINavigationController(rootViewController: dvc)
        presentViewController(nc, animated: true, completion: nil)
    }
    
    //MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        //ReuseIdentifier described in detail on page 144
        
        let item = itemStore.allItems[indexPath.row]
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        
        let currencyFormatter = NSNumberFormatter()
        currencyFormatter.numberStyle = .CurrencyStyle
        cell.valueLabel.text = currencyFormatter.stringFromNumber(item.valueInDollars)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let item = itemStore.allItems[indexPath.row]
            
            let title = "Delete \(item.name)?"
            let message = "Are you sure you want to delete this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: { (action) -> Void in
                self.itemStore.removeItem(item)
                self.imageStore.deleteImageForKey(item.itemKey)
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            })
            ac.addAction(cancelAction)
            ac.addAction(deleteAction)
            
            ac.modalPresentationStyle = .Popover
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                ac.popoverPresentationController?.sourceView = cell
                ac.popoverPresentationController?.sourceRect = cell.bounds
            }
            presentViewController(ac, animated: true, completion: nil)
        }
    }
    
    override func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        itemStore.moveItemAtIndex(sourceIndexPath.row, toIndex: destinationIndexPath.row)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = itemStore.allItems[indexPath.row]
        let dvc = DetailViewController(item: item, imageStore: imageStore)
        showViewController(dvc, sender: self)
    }
    
    
}
