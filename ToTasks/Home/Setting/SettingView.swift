//
//  PaymentMethodButton.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/30/22.
//

import UIKit

protocol SettingViewDelegate: AnyObject {
    func settingViewDelegate(_ settingView: SettingView)
}
class SettingView: UIView {
    
    weak var delegate: SettingViewDelegate?
    
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "mic.fill")?.withConfiguration(UIImage.SymbolConfiguration(pointSize: 18))
        button.setImage(image, for: .normal)
       // button.tintColor = .lightGray
        button.setImage(.forwardImage, for: .normal)
        
        button.tintColor = .orangeColor
        button.clipsToBounds = true
        button.setDemensions(height: 45, width: 45)
        
        return button
    }()
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = UIImage(systemName: "creditcard.fill")
        iv.setDemensions(height: 27, width: 27)
        iv.tintColor = .label
        //iv.tintColor = .yellowColor
        return iv
    }()
    private let rightImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .forwardImage
        iv.setDemensions(height: 30, width: 24)
        iv.tintColor = .yellowColor
        return iv
    }()
    private lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        
        button.setImage(.forwardImage, for: .normal)
        button.setDemensions(height: 24, width: 24)
        button.tintColor = .yellowColor
        return button
    }()
    private let titleTextLabel: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .label
      //  label.text = "Payment method"
        return label
    }()
    private let paymentMethodLabel: UILabel = {
        let label = UILabel()
        label.font = .smallMedium
        label.textColor = .darkGray
        return label
    }()

    convenience init(titleString: String, iconImage: UIImage, secondTitle: String? = nil) {
        self.init()
        
        translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 12
        layer.borderWidth = 3
        layer.borderColor = UIColor.grayColor.cgColor
        
        clipsToBounds = true
        
        titleTextLabel.text = titleString
        paymentMethodLabel.text = secondTitle
        iconImageView.image = iconImage
        
        let stackView = UIStackView(arrangedSubviews: [iconImageView,
                                                       titleTextLabel]).withAttributes(axis: .horizontal, spacing: 15, distribution: .fill)
        
        
        let titleStackView = UIStackView(arrangedSubviews: [stackView, paymentMethodLabel]).withAttributes(axis: .vertical, spacing: 9, distribution: .fill)
        
        addSubview(titleStackView)
        titleStackView.centerY(inView: self,
                               leftAnchor: leftAnchor,
                               rightAnchor: rightAnchor,
                               paddingLeft: 20,
                               paddingRight: 20)
        

        addSubview(rightButton)
        rightButton.centerY(inView: self,
                           rightAnchor: rightAnchor,
                           paddingRight: 20)
        
     
        rightButton.addTarget(self, action: #selector(handleRightButton), for: .touchUpInside)
        
    }
    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    func setPaymentMethod(text: String, iconImage: UIImage) {
        paymentMethodLabel.text = text
        iconImageView.image = iconImage
    }

    @objc func handleRightButton() {
        delegate?.settingViewDelegate(self)
    }
}
