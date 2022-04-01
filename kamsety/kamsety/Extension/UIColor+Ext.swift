//
//  UIColor+Ext.swift
//  kamsety
//
//  Created by Lefdili Alaoui Ayoub on 30/3/2022.
//

import UIKit


extension UIColor {
    
    static var buttonBackgroundColor = UIColor(named: "buttonBackground")!
    static let productColorBorder: UIColor = UIColor(named: "productColorBorder")!
    static let trashBackground: UIColor = UIColor(named: "trashBackground")!
    
    //MARK: - Convert product color
    convenience init(_ hex: String, alpha: CGFloat = 1.0) {
        var cString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if cString.hasPrefix("#") { cString.removeFirst() }
        
        if cString.count != 6 {
            self.init(named: "ff0000")!
            return
        }
        
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }    
}

