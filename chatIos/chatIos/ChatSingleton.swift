//
//  ChatSingleton.swift
//  chatIos
//
//  Created by Asif Junaid on 2/23/16.
//  Copyright © 2016 Asif Junaid. All rights reserved.
//

import UIKit

class ChatSingleton: NSObject {
    var socket: SocketIOClient!
    
    class var sharedInstance : ChatSingleton{
        struct Static {
            static var onceToken : dispatch_once_t = 0
            static var instance : ChatSingleton? = nil
        }
        dispatch_once(&Static.onceToken) {
            Static.instance = ChatSingleton()
        }
        return Static.instance!
    }
    
    func chatInit(){
        self.socket = SocketIOClient(socketURL: Constants.url.chatBaseUrl)
        self.socket.connect()
        self.handlers()

    }
    
    
    func handlers(){
        
        self.socket.on("connect") { (data, ack) -> Void in
           print(data)
        }
        self.socket.on("user joined") { (data, ack) -> Void in
            print("user joined")
            print(data)
        }
        self.socket.on("login") { (data, ack) -> Void in
            print("login")
            print(data)
        }
        
    }
}
