//
//  GlobalObjects.swift
//  chatIos
//
//  Created by Asif Junaid on 2/26/16.
//  Copyright © 2016 Asif Junaid. All rights reserved.
//

import UIKit

class GlobalObjects: NSObject {
    class var sharedInstance: GlobalObjects{
        struct Static{
            static var onceToken : dispatch_once_t = 0
            static var instance: GlobalObjects? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = GlobalObjects()
        })
        return Static.instance!
    }
    var latitude = "12.9335292499163"
    var longitude = "77.6217817571655"
}
