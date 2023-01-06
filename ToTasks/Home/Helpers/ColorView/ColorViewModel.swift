//
//  ColorViewModel.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/9/22.
//

import UIKit

enum Color: Int, CaseIterable {
    
    case orange
    case yellow
    case pink
    case blue
    case green
    case lavender
    case teal
    case olive
    
    var description: String {
        switch self {
        case .orange:
            return "orangeColor"
        case .yellow:
            return "yellowColor"
        case .pink:
            return "pinkColor"
        case .blue:
            return "blueColor"
        case .green:
            return "greenColor"
        case .lavender:
            return "lavenderColor"
        case .teal:
            return "tealColor"
        case .olive:
            return "oliveColor"
        }
    }
 
    var setColor: UIColor {
        switch self {
        case .orange:
            return .orangeColor
        case .yellow:
            return .yellow
        case .pink:
            return .pinkColor
        case .blue:
            return .blueColor
        case .green:
            return .greenColor
        case .lavender:
            return .lavenderColor
        case .teal:
            return .tealColor
        case .olive:
            return .oliveColor
            
        }
    }

}
struct ColorViewModel {
    
    
}
