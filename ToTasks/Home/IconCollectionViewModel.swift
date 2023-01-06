//
//  IconCollectionViewModel.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/23/22.
//

import UIKit

struct IconCollectionViewModel {
    
    private var icon: IconModel
    var section: IconSection
    private var groupValue: String!

    var imageString: String {
        return icon.name
    }
    
    var communication = [String]()
    var weather = [String]()
    var human = [String]()
    var object = [String]()

    var isSelction: Bool? {
        return icon.isIconSelected
    }
    
    init(icon: IconModel, section: IconSection) {
        
        self.icon = icon
        self.section = section
        
        communication = icon.communication
        human = icon.human
        weather = icon.weather
        object = icon.object
      
    }
}
