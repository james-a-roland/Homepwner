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
    
    func setImage(image: UIImage, forKey key:String) {
        imageDictionary[key] = image
    }
    
    func imageForKey(key: String) -> UIImage? {
        return imageDictionary[key]
    }
    
    func deleteImageForKey(key:String) {
        imageDictionary.removeValueForKey(key)
    }
}
