//
//  ViewController.swift
//  chatIos
//
//  Created by Asif Junaid on 2/23/16.
//  Copyright © 2016 Asif Junaid. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChatDelegates ,UITextFieldDelegate{
    @IBOutlet weak var setusername: UIButton!

    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var messageOutlet: UITextField!
    @IBOutlet weak var username: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    var chatMessages = [(String,String)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        ChatSingleton.sharedInstance.chatDelegate = self
         tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        ChatSingleton.sharedInstance.chatInit()
         tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
        tableViewOutlet.hidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        
        messageOutlet.delegate = self
        
    }
    func dismissKeyboard() {
         view.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func login(sender: UIButton) {
        let name = username.text
        if name != ""
        {
            ChatSingleton.sharedInstance.socket.emit("add user", name!)
            usernameStr = name!
            usernameSet()
        }
    }
    var usernameStr = ""
    @IBAction func sendMessage(sender: UIButton) {
        let message = messageOutlet.text
        let str : String = messageOutlet.text!
        ChatSingleton.sharedInstance.socket.emit("new message", message!)
        let user :  String = username.text!
        let tuple = (user,str)
        chatMessages.append(tuple)
        tableViewOutlet.reloadData()
    }
    func usernameSet()
    {
        setusername.hidden = true
        username.hidden = true
        tableViewOutlet.hidden = false

    }
    
    
    //tableview delegates 
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
    // chat delegate
    func receivedChat(message : String,username:String)
    {
        let tuple = (username,message)
        chatMessages.append(tuple)
        tableViewOutlet.reloadData()
    }
    
}

