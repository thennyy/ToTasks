//
//  File.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/19/22.
//

import UIKit

class PremiumImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        let image = UIImage.crownFillImage
        self.image = image
        tintColor = .yellowColor
        backgroundColor = .systemGroupedBackground
        contentMode = .scaleAspectFit
        setDemensions(height: 30, width: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
