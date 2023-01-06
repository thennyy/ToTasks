//
//  ColorExtension.swift
//  EnterAct-Dating
//
//  Created by Thenny Chhorn on 10/15/21.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
}
extension String {
    static let accentStringColor = "orangeColor"
}
extension UIColor {
 
  //  static let accentColor = UIColor.rgb(red: 30, green: 142, blue: 184)
    static let accentGreenColor = UIColor.rgb(red: 3, green: 154, blue: 113)
    static let accentRed = UIColor.systemRed
  //  static let lightAcentColor = UIColor.rgb(red: 32, green: 178, blue: 170)
    static let lightAcentColor = UIColor.rgb(red: 177, green: 0, blue: 232)
    static let defaultGray = UIColor.rgb(red: 230, green: 230, blue: 230)
    static let shareColor = UIColor(white: 1, alpha: 0.2)
    static let shareWhiteColor = UIColor(white: 1, alpha: 0.9)
    static let barDeselectedColor = UIColor(white: 0, alpha: 0.1)
    static let grayColor = UIColor.rgb(red: 248, green: 245, blue: 251)
   // static let pinkColor = UIColor.rgb(red: 209, green: 0, blue: 209)
    static let lightPurlple = UIColor.rgb(red: 224, green: 206, blue: 254)
    static let lavenderColor = UIColor.rgb(red: 193, green: 160, blue: 254)
    static let purple = UIColor.rgb(red: 161, green: 114, blue: 253)
    static let blueColor = UIColor.rgb(red: 162, green: 210, blue: 255)
    static let tealColor = UIColor.rgb(red: 100, green: 223, blue: 223)
    static let greenColor = UIColor.rgb(red: 183, green: 228, blue: 199)
    static let accentColor = UIColor.rgb(red: 242, green: 112, blue: 89)
    static let orangeColor = UIColor.rgb(red: 247, green: 157, blue: 101)
    static let pinkColor = UIColor.rgb(red: 244, green: 185, blue: 178)
    static let yellowColor = UIColor.rgb(red: 247, green: 178, blue: 103)
    static let alarmColor = UIColor.rgb(red: 242, green: 112, blue: 89)
    static let oliveColor = UIColor.rgb(red: 183, green: 183, blue: 164)
    
}
