//
//  Extensions.swift
//  MyNewsApp
//
//  Created by Venkata ramana Kunapuli on 1/19/18.
//  Copyright © 2018 Venkata ramana Kunapuli. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        if(edge != UIRectEdge.all) {
            let border = CALayer()
            
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: thickness)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: thickness, height: self.frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
                break
            default:
                break
            }
            
            border.backgroundColor = color.cgColor;
            
            self.addSublayer(border)
        }
        else {
            let topBorder = CALayer()
            topBorder.frame = CGRect.init(x: 0, y: 0, width: self.frame.width, height: thickness)
            topBorder.backgroundColor = color.cgColor
            self.addSublayer(topBorder)
            
            let bottomBorder = CALayer()
            bottomBorder.frame = CGRect.init(x: 0, y: self.frame.height - thickness, width: self.frame.width, height: thickness)
            bottomBorder.backgroundColor = color.cgColor
            self.addSublayer(bottomBorder)
            
            let leftBorder = CALayer()
            leftBorder.frame = CGRect.init(x: 0, y: 0, width: thickness, height: self.frame.height)
            leftBorder.backgroundColor = color.cgColor
            self.addSublayer(leftBorder)
            
            let rightBorder = CALayer()
            rightBorder.frame = CGRect.init(x: self.frame.width - thickness, y: 0, width: thickness, height: self.frame.height)
            rightBorder.backgroundColor = color.cgColor
            self.addSublayer(rightBorder)
        }
    }
}

/*
 extension NSMutableAttributedString {
 @discardableResult func bold(_ text:String) -> NSMutableAttributedString {
 let attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 14)]
 let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
 self.append(boldString)
 return self
 }
 
 @discardableResult func color(_ text:String, color: UIColor) -> NSMutableAttributedString {
 let attrs:[String:AnyObject] = [NSForegroundColorAttributeName : color]
 let colorString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
 
 self.append(colorString)
 return self
 }
 
 @discardableResult func fontSize(_ text:String, fontSize: CGFloat) -> NSMutableAttributedString {
 
 let font = UIFont(name: "Lato-Regular", size: fontSize)
 
 let attrs:[String:AnyObject] = [NSFontAttributeName : font!]
 let resString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
 
 self.append(resString)
 return self
 }
 
 @discardableResult func normal(_ text:String)->NSMutableAttributedString {
 let normal =  NSAttributedString(string: text)
 self.append(normal)
 return self
 }
 }
 */



extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    func toString( dateFormat format  : DateFormatter ) -> String
    {
        return format.string(from: self)
    }
    
    func toISO() -> String {
        let dateformattor = DateFormatter()
        dateformattor.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateformattor.string(from: self)
    }
    
    func toUTC() -> String {
        let dateformattor = DateFormatter()
        //        dateformattor.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        dateformattor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss ZZZ"
        
        dateformattor.timeZone = NSTimeZone.init(abbreviation: "UTC") as TimeZone!
        return dateformattor.string(from: self)
    }
    
}

extension NSLocale {
    
    struct Locale {
        let countryCode: String
        let countryName: String
    }
    
    class func locales() -> [Locale] {
        
        var locales = [Locale]()
        for localeCode in NSLocale.isoCountryCodes {
            let countryName = (self.current as NSLocale).displayName(forKey: NSLocale.Key.countryCode, value: localeCode) ?? ""
            let countryCode = localeCode
            let locale = Locale(countryCode: countryCode, countryName: countryName)
            locales.append(locale)
        }
        
        return locales
    }
    
}

extension UIViewController {
    
    func setupViewResizerOnKeyboardShown() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UIViewController.keyboardWillShowForResizing),
                                               name: Notification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(UIViewController.keyboardWillHideForResizing),
                                               name: Notification.Name.UIKeyboardWillHide,
                                               object: nil)
    }
    
    @objc func keyboardWillShowForResizing(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = self.view.window?.frame {
            // We're not just minusing the kb height from the view height because
            // the view could already have been resized for the keyboard before
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                
                self.view.frame = CGRect(x: self.view.frame.origin.x,
                                         y: self.view.frame.origin.y,
                                         width: self.view.frame.width,
                                         height: window.origin.y + window.height - keyboardSize.height)
            })
        }
    }
    
    @objc func keyboardWillHideForResizing(notification: Notification) {
        if let window = self.view.window?.frame {
            
            UIView.animate(withDuration: 0.1, animations: { () -> Void in
                
                self.view.frame = CGRect(x: self.view.frame.origin.x,
                                         y: self.view.frame.origin.y,
                                         width: self.view.frame.width,
                                         height: window.height)
            })
            
        }
    }
}

extension UIView {
    
    func dropShadow(scale: Bool) {
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        
        
        self.layer.shadowOpacity = 0.25
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        
        self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 4, height: 4)).cgPath
        //        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    func dropShadow(scale: Bool = true, width:Int?, height:Int?, opacity:Float?) {
        
        self.dropShadow(scale: scale)
        
        if let opacity = opacity {
            self.layer.shadowOpacity = opacity
        }
        
        if let width = width, let height = height {
            self.layer.shadowOffset = CGSize(width: width, height: height)
        }
    }
    
    
    
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [5,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
    
    
    func addLeftDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: 0, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = kCALineJoinRound
        
        shapeLayer.lineDashPattern = [5,4] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 0, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
}

class ShadowView: UIView {
    override var bounds: CGRect {
        didSet {
            setupShadow()
        }
    }
    
    private func setupShadow() {
        self.layer.cornerRadius = 4
        self.layer.shadowOffset = CGSize(width: 2, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.25
        self.layer.shadowPath = UIBezierPath(roundedRect: self.layer.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 4, height: 4)).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}


extension UIToolbar {
    
    
    func ToolbarPiker(done: Selector, next: Selector) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        let defaultBlueColor = UIColor(red: 0/255.0, green: 122/255.0, blue: 255/255.0, alpha: 1.0)
        
        toolBar.barStyle = UIBarStyle.default
        
        toolBar.barTintColor = UIColor(red: 246/255, green: 246/255, blue: 246/255, alpha: 0.9)
        
        toolBar.isTranslucent = false
        toolBar.tintColor = defaultBlueColor
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: done)
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: next)
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolBar.setItems([nextButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    
    
    func CustomToolbarPiker(leftButton: Selector?, rightButton: Selector?, titleText: String?, tintColor: UIColor?, backgroundColor: UIColor?) -> UIToolbar {
        
        let toolBar = UIToolbar()
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.backgroundColor = backgroundColor
        toolBar.tintColor = tintColor
        
        
        
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: leftButton)
        let nextButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: rightButton)
        
        var titleTextFinal: String = ""
        if let tempText = titleText {
            titleTextFinal = tempText
        }
        
        
        let spaceButton = UIBarButtonItem(title: titleTextFinal, style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        spaceButton.tintColor = UIColor.black
        
        toolBar.setItems([nextButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
}


extension UIImage {
    static func from(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    func resizeImage(newWidth: CGFloat)->UIImage{
        let scale = newWidth/self.size.width
        let newHeight = scale * self.size.height
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newWidth))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func fixOrientation() -> UIImage {
        if self.imageOrientation == UIImageOrientation.up {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        let normalizedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return normalizedImage;
    }
    
    
    
}

/// A generic protocol for creating objects which can be converted to JSON
protocol JSONSerializable {
    var dict: [String: Any] { get }
}

extension JSONSerializable {
    /// Converts a JSONSerializable conforming class to a JSON object.
    func toJSON() -> Data? {
        return try? JSONSerialization.data(withJSONObject: dict, options: [.prettyPrinted])
    }
}




extension String {
    func capitalizingFirstLetter() -> String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst())
        return first + other
    }
    
    func lowerCaseAllButFirst()->String {
        let first = String(characters.prefix(1))
        let other = String(characters.dropFirst()).lowercased()
        return first + other
    }
    
    func getCapitalizeFirstAndLowerCaseOthers()->String {
        let first = String(characters.prefix(1)).capitalized
        let other = String(characters.dropFirst()).lowercased()
        return first + other
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    mutating func lowercaseAllbutFirst(){
        self = self.lowerCaseAllButFirst()
    }
    
    mutating func capitalizeFirstAndLowerCaseOthers(){
        self = self.capitalizingFirstLetter()
        self = self.lowerCaseAllButFirst()
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
}



extension UIStackView {
    
    override open var backgroundColor: UIColor? {
        
        get {
            return super.backgroundColor
        }
        
        set {
            
            super.backgroundColor = newValue
            
            let tag = -9999
            for view in subviews where view.tag == tag {
                view.removeFromSuperview()
            }
            
            let subView = UIView()
            subView.tag = tag
            subView.backgroundColor = newValue
            subView.translatesAutoresizingMaskIntoConstraints = false
            //self.addSubview(subView)
            self.insertSubview(subView, at: 0)
            subView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
            subView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
            subView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
            subView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        }
        
    }
}




