//
//  ItemList.swift
//  RednGreen
//
//  Created by Thenny Chhorn on 11/15/22.
//

import UIKit

struct Foods: Decodable {
    
    var name: String
    var category: String
    var image: String
    var descriptionText: String?
    var time: Date? 
    
    init(dictionary: [String:Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.category = dictionary["category"] as? String ?? ""
        self.image = dictionary["image"] as? String ?? ""

    }
}
