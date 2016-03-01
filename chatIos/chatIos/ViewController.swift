//
//  ViewController.swift
//  chatIos
//
//  Created by Asif Junaid on 2/23/16.
//  Copyright © 2016 Asif Junaid. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,ChatDelegates ,UITextFieldDelegate,CLLocationManagerDelegate{
    @IBOutlet weak var setusername: UIButton!
    @IBOutlet weak var passwordOutlet: UITextField!
    @IBOutlet weak var tableViewOutlet: UITableView!
    @IBOutlet weak var messageOutlet: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    
    var locationManager: CLLocationManager!
    var chatMessages = [(String,String)]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        ChatSingleton.sharedInstance.chatDelegate = self
        
        tableViewOutlet.delegate = self
        
        tableViewOutlet.dataSource = self
        
        
        tableViewOutlet.tableFooterView = UIView(frame: CGRectZero)
        
        tableViewOutlet.hidden = true
        messageOutlet.hidden = true
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        messageOutlet.delegate = self
        
    }
    
    func dismissKeyboard() {
         view.endEditing(true)
    }
    //MARK : Location functions
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        print("lat value \(newLocation.coordinate.latitude)")
        print("lon value \(newLocation.coordinate.longitude)")
        
    }
    
    func getCurrentLocation(){
        
        self.locationManager = CLLocationManager()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            self.locationManager.startUpdatingLocation()
            
            let location = locationManager.location
            if location != nil{
                var coord = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
                coord = (location?.coordinate)!
                
                GlobalObjects.sharedInstance.latitude = "\(coord.latitude)"
                GlobalObjects.sharedInstance.longitude = "\(coord.longitude)"
                
                print("current lat/long: \(GlobalObjects.sharedInstance.latitude) \(GlobalObjects.sharedInstance.longitude)")
                
            }
            
        }
        
    }
    
    //MARK : actions
    @IBAction func login(sender: UIButton) {
        let name = username.text
        let password = passwordOutlet.text
        if name != "" && password != ""
        {
            usernameStr = name!
            let dict : NSDictionary = ["username":username.text!,"password":passwordOutlet.text!]

            callApiForLoginOrSignUP(dict)
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
    
    
    
    //MARK : Socket delegates
    func receivedChat(message : String,username:String)
    {
        let tuple = (username,message)
        chatMessages.append(tuple)
        tableViewOutlet.reloadData()
    }
    
    
    
    //login functions
    func userHasLoggedIn()
    {
        setusername.hidden = true
        username.hidden = true
        passwordOutlet.hidden = true
        messageOutlet.hidden = false
        tableViewOutlet.hidden = false
        ChatSingleton.sharedInstance.chatInit()
        ChatSingleton.sharedInstance.socket.emit("add user", username.text!)
        
    }
    
    
    
    //MARK: API calls
    func callApiForLoginOrSignUP(data : NSDictionary){
 
        RemoteRequest.sharedInstance.POST(Constants.url.loginOrSignupUrl!, params: data as? [String : AnyObject], onSuccess: { (data) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                self.userHasLoggedIn()
            }
            
            }) { (message) -> Void in
                print(message)
        }
    }

    
    
}

