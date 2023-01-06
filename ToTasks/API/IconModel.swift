//
//  IconModel.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/23/22.
//

import UIKit

enum IconSection: Int, CaseIterable {
   
    case communication
    case weather
    case human
    case object

    var description: String {
        switch self {
        case .communication:
            return "Communication"
        case .weather:
            return "Weather"
        case .human:
            return "Human"
        case .object:
            return "Objects"
        }
    }
}
struct IconModel {
    
    var name: String
    var group: String
    var isIconSelected: Bool?
    
    var communication = [String]()
    var weather = [String]()
    var human = [String]()
    var object = [String]()
    
}

