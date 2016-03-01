//
//  RemoteRequest.swift
//  chatIos
//
//  Created by Asif Junaid on 2/26/16.
//  Copyright © 2016 Asif Junaid. All rights reserved.
//

import UIKit

class RemoteRequest {
    func GET(url:NSURL, params:[String:AnyObject]?, onSuccess:((data: AnyObject) -> Void)?, onFail:((message:String) -> Void)?){
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if(params != nil){
            do{
                try request.HTTPBody =  NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted)
                
            }
            catch{
                
            }
            
        }
        
        Req(request, onSuccess: onSuccess, onFail: onFail)
    }
    
    func POST(url:NSURL, params:[String:AnyObject]?, onSuccess:((data:AnyObject) -> Void)?, onFail:((message:String) -> Void)?){
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        if params != nil{
            do{
                try request.HTTPBody = NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted)
            }
            catch{
            }
        }
        Req(request, onSuccess: onSuccess, onFail: onFail)
    }
    
    func GETImages(url:NSURL, params:[String:AnyObject]?, onSuccess:((image:UIImage) -> Void)?, onFail:((message:String) -> Void)?){
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if(params != nil){
            do{
                try request.HTTPBody =  NSJSONSerialization.dataWithJSONObject(params!, options: NSJSONWritingOptions.PrettyPrinted)
                
            }
            catch{
                
            }
            
        }
        getImageReq(request, onSuccess: onSuccess, onFail: onFail)
    }
    
    func getImageReq(request: NSMutableURLRequest, onSuccess:((data: UIImage) -> Void)?, onFail:((message:String) -> Void)?)
    {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if error == nil{
                let res = response as! NSHTTPURLResponse!
                
                switch res.statusCode {
                case 200:
                    fallthrough
                case 204:
                    if data != nil {
                        
                        do{
                            let image = try UIImage(data: data!)!
                            onSuccess!(data: image)
                            return
                        }
                        catch{
                            onFail!(message: "No data received")
                        }
                    }
                case 201 :
                    if data != nil {
                        
                        do{
                            let image = try UIImage(data: data!)!
                            onSuccess!(data: image)
                            return
                        }
                        catch{
                            onFail!(message: "No data received")
                        }
                    }
                case 401 :
                    onFail!(message: "Invalid Credentials")
                    return
                case 409 :
                    onFail!(message: "Conflict")
                    return
                case 404 :
                    onFail!(message: "Not Found")
                    return
                case 400:
                    onFail!(message: "Bad Request")
                    return
                case 403:
                    onFail!(message: "Unauthorized Cookie")
                    return
                default :
                    onFail!(message : "Internal Server Error")
                    return
                }
            }else if (error?.code == -1012){
                onFail!(message: "Invalid Credentials")
                return
            }else if (error?.code == -1001){
                onFail!(message: "No Internet Connection")
            }else if (error?.code == -1004){
                onFail!(message: "Could not connect to server")
                return
            }
            else{
                onFail!(message: "Internal Server Error")
                return
            }
        }
        
        task.resume()
    }
    
    
    func Req(request: NSMutableURLRequest, onSuccess:((data: AnyObject) -> Void)?, onFail:((message:String) -> Void)?)
    {
        let session = NSURLSession.sharedSession()
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) -> Void in
            if data != nil{
                let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("data: \(datastring!)")
            }
            if error == nil{
                let res = response as! NSHTTPURLResponse!
                
                switch res.statusCode {
                case 200:
                    fallthrough
                case 204:
                    if data != nil {
                        
                        do{
                            let jsonResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                            let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            if datastring == ""{
                                onSuccess!(data: [])
                                return
                            }
                            onSuccess!(data: jsonResult)
                            return
                        }
                        catch{
                            let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            if datastring != nil{
                                onSuccess!(data: data!)
                                return
                            }
                        }
                    }
                case 201 :
                    if data != nil {
                        
                        do{
                            let jsonResult: AnyObject = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers)
                            let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            if datastring == ""{
                                onSuccess!(data: [])
                                return
                            }
                            onSuccess!(data: jsonResult)
                            return
                        }
                        catch{
                            let datastring = NSString(data: data!, encoding: NSUTF8StringEncoding)
                            if datastring != nil{
                                onSuccess!(data: data!)
                                return
                            }
                        }
                    }
                case 401 :
                    onFail!(message: "Invalid Credentials")
                    return
                case 409 :
                    onFail!(message: "Conflict")
                    return
                case 404 :
                    onFail!(message: "Not Found")
                    return
                case 400:
                    onFail!(message: "Bad Request")
                    return
                case 403:
                    onFail!(message: "Unauthorized Cookie")
                    return
                default :
                    onFail!(message : "Internal Server Error")
                    return
                }
            }else if (error?.code == -1012){
                onFail!(message: "Invalid Credentials")
                return
            }else if (error?.code == -1001){
                onFail!(message: "No Internet Connection")
            }else if (error?.code == -1004){
                onFail!(message: "Could not connect to server")
                return
            }
            else{
                onFail!(message: "Internal Server Error")
                return
            }
        }
        
        task.resume()
    }
    
    
    
    class var sharedInstance: RemoteRequest{
        struct Static{
            static var onceToken : dispatch_once_t = 0
            static var instance: RemoteRequest? = nil
        }
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = RemoteRequest()
        })
        return Static.instance!
    }
    
    
    
}