//
//  HttpService.swift
//  MyNewsApp
//
//  Created by Venkata ramana Kunapuli on 1/19/18.
//  Copyright © 2018 Venkata ramana Kunapuli. All rights reserved.
//

import Foundation
import UIKit

enum AppError: Error {
    case unknownError
    case serverError
}
class HttpService: NSObject, URLSessionDelegate {
    
    //    let baseUrl = "https://localhost:8080/i94-services"
    //let baseUrl = "https://i94public-dev.cbp.dhs.gov/i94-services"
    //    let baseUrl = "https://mobile-dev.cbp.dhs.gov/i94/i94-services"
    let baseUrl = "http://localhost:8443/i94-services"
    
    
    func doPost(params: Dictionary<String, Any>, check401: Bool?=true, serverMethod : String, callback : @escaping (Dictionary<String, Any>?, URLResponse?, Error?) -> Void) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let url = serverMethod
        var urlRequest = URLRequest(url: URL(string:url)!)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        var jsonData : Data
        let paramsForJson = convertParamsDatesToString(params: params)
        jsonData = try! JSONSerialization.data(withJSONObject: paramsForJson, options: .prettyPrinted)
        urlRequest.httpBody = jsonData
        //        let urlSession = URLSession.init(configuration: .default)
        let urlSession = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
        let dataTask = urlSession.dataTask(with: urlRequest as URLRequest) { (data, response, err) in
            
            var error = err
            let response = response
            let data = data
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode >= 400){
                    if(error == nil) {
                        error = AppError.serverError
                    }
                }
                if(httpResponse.statusCode == 0 || httpResponse.statusCode == 503){
                    //UserService.isOnline = false
                }
                
                if(httpResponse.statusCode == 401 && check401!){
                    DispatchQueue.main.async {
                        guard let appD = UIApplication.shared.delegate as? AppDelegate else {
                            fatalError("Unable to get AppDelegate")
                        }
                        //Delete the app cookies
                        HttpService.deleteCookies()
                    }
                }
                
                print(url)
                print("statusCode: \(httpResponse.statusCode)")
            } else {
                //TODO: Figure out if this is necessary
                //UserService.isOnline = false
            }
            
            
            if(error != nil) {
                // Make async call
                DispatchQueue.main.async {
                    callback(nil, nil, error)
                }
            }
            else {
                
                //UserService.isOnline = true
                
                
                var jsonData: Dictionary<String, Any>?
                
                do {
                    try jsonData = (JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? Dictionary<String, Any>)!
                } catch let parsingError as NSError {
                    print(parsingError.description)
                }
                
                // Make async call
                DispatchQueue.main.async {
                    callback(jsonData, response, error)
                }
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
        }
        dataTask.resume()
    }
    
    
    
    func doGet(serverMethod : String, check401: Bool?=true, callback : @escaping (Dictionary<String, Any>?, URLResponse?, Error?) -> Void) {
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        
        let urlstr = serverMethod
        let url1 = URL(string:urlstr)
        print(url1?.absoluteString)
        var urlRequest = URLRequest(url: url1!)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        
        //        let urlSession = URLSession.init(configuration: .default)
        let urlSession = URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
        let dataTask = urlSession.dataTask(with: urlRequest as URLRequest) { (data, response, err) in
            
            var error = err
            let response = response
            let data = data
            
            if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode >= 400){
                    if(error == nil) {
                        error = AppError.serverError
                    }
                }
                
                if(httpResponse.statusCode == 0 || httpResponse.statusCode == 503){
                    //UserService.isOnline = false
                }
                
                if(httpResponse.statusCode == 401 && check401!){
                    
                    DispatchQueue.main.async {
                        guard let appD = UIApplication.shared.delegate as? AppDelegate else {
                            fatalError("Unable to get AppDelegate")
                        }
                        //Delete the app cookies
                        HttpService.deleteCookies()
                    }
                }
                
                print(url1)
                print("statusCode: \(httpResponse.statusCode)")
            } else {
                //TODO: Figure out if this is necessary
                //UserService.isOnline = false
            }
            
            if(error != nil){
                // Make async call
                DispatchQueue.main.async {
                    callback(nil, nil, error)
                }
            } else {
                
                // UserService.isOnline = true
                
                var jsonData: Dictionary<String, Any>?
                
                do {
                    try jsonData = (JSONSerialization.jsonObject(with: data!, options: .mutableLeaves) as? Dictionary<String, Any>)!
                } catch let parsingError as NSError {
                    print(parsingError.description)
                }
                
                // Make async call
                DispatchQueue.main.async {
                    callback(jsonData, response, error)
                }
            }
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
        }
        dataTask.resume()
    }
    
    
    
    func convertParamsDatesToString(params: Dictionary<String, Any>)->Dictionary<String, Any>{
        
        var paramsToReturn = params
        
        for(key, value) in paramsToReturn {
            if let date = value as? Date {
                paramsToReturn[key] = date.toISO()
            }
        }
        
        return paramsToReturn
    }
    
    
    
    static func showCookies() {
        
        let cookieStorage = HTTPCookieStorage.shared
        //println("policy: \(cookieStorage.cookieAcceptPolicy.rawValue)")
        
        if let cookies = cookieStorage.cookies {
            print("Cookies.count: \(cookies.count)")
            for cookie in cookies {
                var cookieProperties = [HTTPCookiePropertyKey:Any]()
                
                cookieProperties[HTTPCookiePropertyKey.name] = cookie.name
                cookieProperties[HTTPCookiePropertyKey.value] = cookie.value
                cookieProperties[HTTPCookiePropertyKey.domain] = cookie.domain
                cookieProperties[HTTPCookiePropertyKey.path] = cookie.path
                cookieProperties[HTTPCookiePropertyKey.version] = NSNumber(value: cookie.version)
                cookieProperties[HTTPCookiePropertyKey.expires] = cookie.expiresDate
                cookieProperties[HTTPCookiePropertyKey.secure] = cookie.isSecure
                
                print("ORGcookie: \(cookie)")
            }
        }
    }
    
    static func deleteCookies(){
        
        let cookieStorage = HTTPCookieStorage.shared
        
        if let cookies = cookieStorage.cookies {
            for cookie in cookies {
                HTTPCookieStorage.shared.deleteCookie(cookie)
            }
        }
    }
    
    
    
    //BEWARE THIS METHOD WILL TRUST ALL SSL CERIFICATES. FOR TESTING PURPOSES ONLY
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        
        if challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust {
            let credential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
            completionHandler(URLSession.AuthChallengeDisposition.useCredential, credential)
        }
    }
    
}
