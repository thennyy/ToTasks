//
//  NavigationView.swift
//  Cupatea
//
//  Created by Thenny Chhorn on 10/14/22.
//

import UIKit
protocol NavigationViewDelegate: AnyObject {
   
    func navigationView(_ view: NavigationView, leftButton: UIButton)
    func navigationView(_ view: NavigationView, rightButton: UIButton)
    
}
class NavigationView: UIView {
    
    weak var delegate: NavigationViewDelegate?
    
    var isRightButtonChanged = false
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .regularBold 
        label.textAlignment = .center
        return label
    }()
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.setImage(.filterImage, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
       // button.tintColor = .white
        button.titleLabel?.font = .regularMedium
        return button
    }()
 
    convenience init(title: String? = nil, textAlignment: NSTextAlignment? = .center, leftButtonImage: UIImage? = nil, rightButtonImage: UIImage? = .none, rightString: String? = nil, rightButtonColor: UIColor? = .orangeColor) {
        self.init()

        backgroundColor = .systemGroupedBackground
        
        leftButton.setImage(leftButtonImage, for: .normal)
        rightButton.setImage(rightButtonImage, for: .normal)
        
        rightButton.setTitle(rightString, for: .normal)
        
        rightButton.tintColor = rightButtonColor
        
        titleLabel.text = title
        
        addSubview(titleLabel)
        titleLabel.textAlignment = textAlignment!
        
        titleLabel.centerX(inView: self,
                           bottomAnchor: bottomAnchor,
                           paddingBottom: 20)
        
        addSubview(leftButton)
        leftButton.setDemensions(height: 36, width: 36)
        leftButton.centerY(inView: titleLabel,
                           leftAnchor: leftAnchor,
                           paddingLeft: 20)

        addSubview(rightButton)
        rightButton.centerY(inView: titleLabel,
                            rightAnchor: rightAnchor,
                            paddingRight: 20)
        
        
        rightButton.addTarget(self, action: #selector(handleRightButton), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(handleLeftButton), for: .touchUpInside)
        
    }

    @objc func handleLeftButton(_ sender: UIButton) {
        delegate?.navigationView(self, leftButton: sender)
    }
    @objc func handleRightButton(_ sender: UIButton) {
        delegate?.navigationView(self, rightButton: sender)
    }
    func changeRightButton() {
        rightButton.setTitle("Save", for: .normal)
        rightButton.setImage(.none, for: .normal)
        disableRightButton()
        isRightButtonChanged = true
        
    }
    func revertRightButton() {
        rightButton.setImage(.addImage, for: .normal)
        rightButton.setTitle("", for: .normal)
        enableRightButton()
        isRightButtonChanged = false 
    }
    
    func enableRightButton() {
        rightButton.isEnabled = true
    }
    func disableRightButton() {
        rightButton.isEnabled = false
    }
}
