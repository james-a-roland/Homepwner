//
//  ImageStore.swift
//  Homepwner
//
//  Created by James Roland on 9/16/15.
//  Copyright (c) 2015 LinkedIn. All rights reserved.
//

import UIKit

class ImageStore: NSObject {
    var imageDictionary = [String:UIImage]()
    
    override init() {
        super.init()
        
        let nc = NSNotificationCenter.defaultCenter()
        nc.addObserver(self, selector: "clearCache:", name: UIApplicationDidReceiveMemoryWarningNotification, object: nil)
    }
    
    func setImage(image: UIImage, forKey key:String) {
        imageDictionary[key] = image
        
        let imageURL = imageURLForKey(key)
        let data = UIImageJPEGRepresentation(image, 0.5)
        data.writeToURL(imageURL, atomically: true)
    }
    
    func imageForKey(key: String) -> UIImage? {
        if let existingImage = imageDictionary[key] {
            return existingImage
        }
        let imageUrl = imageURLForKey(key)
        if let imageFromDisk = UIImage(contentsOfFile: imageUrl.path!) {
            imageDictionary[key] = imageFromDisk
            return imageFromDisk
        }
        return nil
    }
    
    func deleteImageForKey(key:String) {
        imageDictionary.removeValueForKey(key)
        
        let imageURL = imageURLForKey(key)
        NSFileManager.defaultManager().removeItemAtURL(imageURL, error: nil)
    }
    
    func imageURLForKey(key:String) -> NSURL {
        let documentsDirectories =
        NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = documentsDirectories.first as! NSURL
        return documentDirectory.URLByAppendingPathComponent(key)
    }
    
    func clearCache(note: NSNotification) {
        println("Flushing \(imageDictionary.count) images out of the cache")
        imageDictionary.removeAll(keepCapacity: false)
    }
}
