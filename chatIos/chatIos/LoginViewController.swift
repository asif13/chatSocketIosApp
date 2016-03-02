//
//  LoginViewController.swift
//  chatIos
//
//  Created by Asif Junaid on 3/2/16.
//  Copyright © 2016 Asif Junaid. All rights reserved.
//

import UIKit
import CoreLocation

class LoginViewController: UIViewController,CLLocationManagerDelegate,UITextFieldDelegate {

    @IBOutlet weak var textFieldForUsername: UITextField!
    @IBOutlet weak var buttonForUsername: UIButton!
    var isPromptedForUsername = true
    var isCurrentLocationFetched = false
    var username = ""
    var password = ""
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        textFieldForUsername.delegate = self
        textFieldForUsername.placeholder = "username"
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func usernamePasswordClicked(sender: UIButton) {
        if isPromptedForUsername{
            username = textFieldForUsername.text!
            isPromptedForUsername = false
            textFieldForUsername.text = ""
            textFieldForUsername.placeholder = "password"
        }
        else{
            password = textFieldForUsername.text!
            getCurrentLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        print("lat value \(newLocation.coordinate.latitude)")
        print("lon value \(newLocation.coordinate.longitude)")
        GlobalObjects.sharedInstance.latitude = " \(newLocation.coordinate.latitude)"
        GlobalObjects.sharedInstance.longitude = " \(newLocation.coordinate.longitude)"
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
                isCurrentLocationFetched = true
                 callApiToLogInOrSignUp()
            }
            
        }
        
    }
    
    func callApiToLogInOrSignUp(){
        
        let data = ["username":username,"password":password,"latitude":GlobalObjects.sharedInstance.latitude,"longitude":GlobalObjects.sharedInstance.longitude]
        RemoteRequest.sharedInstance.POST(Constants.url.loginOrSignupUrl!, params: data as? [String : String], onSuccess: {
            (data) -> Void in
            dispatch_async(dispatch_get_main_queue()) {
                GlobalObjects.sharedInstance.username = self.username
                 var chatScreen = UIStoryboard(name: "chatScreen", bundle: nil).instantiateViewControllerWithIdentifier("chatScreen") as! ChatScreenViewController
                self.navigationController?.pushViewController(chatScreen, animated: true)

            }
            
            }) { (message) -> Void in
                print("error")
                print(message)
        }
    }
    

    
    
}
