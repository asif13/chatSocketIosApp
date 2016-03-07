//
//  ChatScreenViewController.swift
//  chatIos
//
//  Created by Asif Junaid on 3/2/16.
//  Copyright © 2016 Asif Junaid. All rights reserved.
//

import UIKit

class ChatScreenViewController: UIViewController,ChatDelegates,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var messageOutlet: UITextField!
    var chatMessages = [(String,String)]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        ChatSingleton.sharedInstance.chatDelegate = self
        ChatSingleton.sharedInstance.chatInit()
        ChatSingleton.sharedInstance.socket.emit("add user", GlobalObjects.sharedInstance.username)
    }
    
    
    @IBAction func sendMessage(sender: UIButton) {
        let message = messageOutlet.text
        let str : String = messageOutlet.text!
        ChatSingleton.sharedInstance.socket.emit("new message", message!)
        let user :  String = GlobalObjects.sharedInstance.username
        let tuple = (user,str)
        chatMessages.append(tuple)
        tableViewOutlet.reloadData()
        messageOutlet.text = ""
    }
    //MARK : Socket delegates
    func receivedChat(message : String,username:String)
    {
        let tuple = (username,message)
        chatMessages.append(tuple)
        tableViewOutlet.reloadData()
    }
    
    
    //MARK : tableview delegate .
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatMessages.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! ChatTableViewCell
        cell.username.text = chatMessages[indexPath.row].0
        cell.message.text = chatMessages[indexPath.row].1
        return cell
    }
    

}
