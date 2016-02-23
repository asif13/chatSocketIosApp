//
//  ViewController.swift
//  chatIos
//
//  Created by Asif Junaid on 2/23/16.
//  Copyright © 2016 Asif Junaid. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var setusername: UIButton!

    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var messageOutlet: UITextField!
    @IBOutlet weak var username: UITextField!
    var chatMessages = [(String,String)]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableViewOutlet.delegate = self
        tableViewOutlet.dataSource = self
        ChatSingleton.sharedInstance.chatInit()
        ChatSingleton.sharedInstance.handlers()
        tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
        tableViewOutlet.hidden = true
        chatMessages.append(("asd","hi"))
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
            usernameSet()
        }
    }
    
    @IBAction func sendMessage(sender: UIButton) {
        
        
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

}

