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
    
    init(itemStore: ItemStore) {
        self.itemStore = itemStore
        super.init(nibName: nil, bundle: nil)
        
        for _ in 0..<5 {
            self.itemStore.createItem()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        tableView.registerClass(UITableViewCell.self,
//            forCellReuseIdentifier: "UITableViewCell")
        let nib = UINib(nibName: "ItemCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ItemCell")
        tableView.rowHeight = 44
    }
    
    required init!(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemStore.allItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .Default, reuseIdentifier: "UITableViewCell")
//        let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath) as! UITableViewCell
        let cell = tableView.dequeueReusableCellWithIdentifier("ItemCell", forIndexPath: indexPath) as! ItemCell
        //ReuseIdentifier described in detail on page 144
        
        let item = itemStore.allItems[indexPath.row]
        cell.nameLabel.text = item.name
        cell.serialNumberLabel.text = item.serialNumber
        cell.valueLabel.text = "$\(item.valueInDollars)"
        
        return cell
    }
    
    
}
