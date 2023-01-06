//
//  ViewModel.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/6/22.
//

import UIKit

struct AllCategoryViewModel {
    
    var category: Category
    var indexPath: IndexPath?


    var showAlarm: Bool {
        return (category.alarm != nil) ? false : true
    }
    var alertColor: UIColor {
        return (category.alarm != nil) ? .red : .black 
    }
    var categoryName: String {
        return category.name ?? ""
    }
    var iconImage: UIImage {
        return UIImage(systemName: category.image ?? "star.fill") ?? UIImage(systemName: "star.fill")!
    }
    var royaltyColor: UIColor {
        return (category.color == "yellowColor") ? UIColor.alarmColor : UIColor.alarmColor 
    }
    var time: Date {
        return category.time ?? Date()
    }
    var setTimeToAlert: Date {
        return category.alarm ?? Date()
    }
    var selectedBackGroundColor: String {
        return category.color ?? "orangeColor"
    }
    
    var backGroundColor: UIColor {
        
        switch category.color {
        case "orangeColor":
            return .orangeColor
        case "yellowColor":
            return .yellowColor
        case "pinkColor":
            return .pinkColor
        case "blueColor":
            return  .blueColor
        case "greenColor":
            return .greenColor
        case "lavenderColor":
            return .lavenderColor
        case "tealColor":
            return .tealColor
        case "oliveColor":
            return .oliveColor
        default:
            return .orangeColor
        }
    }
    init(category: Category, indexPath: IndexPath? = nil) {
        self.category = category
        self.indexPath = indexPath
    }
    
}
