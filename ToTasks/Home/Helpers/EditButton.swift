//
//  EditTaskButton.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/22/22.
//

import UIKit

class EditButton: UIButton {
    
    private let iconImage: UIImageView = {
        let ig = UIImageView()
        ig.contentMode = .scaleAspectFit
        ig.tintColor = .label
        ig.setDemensions(height: 30, width: 30)
        return ig
    }()
    convenience init(title: String,
                     titleColor: UIColor? = .orangeColor,
                     image: UIImage? = nil,
                     radius: CGFloat? = 9,
                     background: UIColor? = .systemGroupedBackground,
                     borderWidth: CGFloat? = 3,
                     borderColor: UIColor? = .clear) {
        
        self.init(type: ButtonType.system)
        
        titleLabel?.font = .regularMedium
        setTitle("  " + title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        layer.cornerRadius = radius!
        backgroundColor = .systemGroupedBackground
        layer.borderWidth = borderWidth!
        layer.borderColor = borderColor?.cgColor
        setImage(image, for: .normal)
        tintColor = titleColor
        
    }
}

