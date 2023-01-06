//
//  AddTaskNavigationView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/25/22.
//

import UIKit

protocol AddTaskNavigationViewDelegate: AnyObject {
    func addTaskNavigationView(_ view: AddTaskNavigationView, rightButton: UIButton)
    func addTaskNavigationView(_ view: AddTaskNavigationView, leftButton: UIButton)
    func addTaskNavigationView(_ setReminderButton: UIButton)
}
class AddTaskNavigationView: UIView {
  
    weak var delegate: AddTaskNavigationViewDelegate?
    
    var viewModel: AllCategoryViewModel! {
        didSet {
           // setReminderButton.tintColor = viewModel.alertColor
        }
    }
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .titleMedium
        label.textAlignment = .center
        return label
    }()
    
    private let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.setImage(.filterImage, for: .normal)
        button.tintColor = .black
        button.setDemensions(height: 36, width: 36)
        return button
    }()
//    private lazy var setReminderButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.clipsToBounds = true
//        button.contentMode = .scaleAspectFit
//        button.setImage(.setReminderImage, for: .normal)
//        button.setDemensions(height: 36, width: 36)
//        button.addTarget(self, action: #selector(handleSetReminderButton),
//                         for: .touchUpInside)
//        return button
//    }()
    lazy var rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.contentMode = .scaleAspectFill
        button.titleLabel?.font = .regularMedium
        return button
        
    }()
 
    convenience init(title: String? = nil, textAlignment: NSTextAlignment? = .center, leftButtonImage: UIImage? = nil, rightButtonImage: UIImage? = .none, rightString: String? = nil, rightButtonColor: UIColor? = .orangeColor) {
        self.init()

        backgroundColor = .white
        
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
        delegate?.addTaskNavigationView(self, leftButton: sender)
    }
    @objc func handleRightButton(_ sender: UIButton) {

        delegate?.addTaskNavigationView(self, rightButton: sender)
        
    }
  

    func enableRightButton() {
        rightButton.isEnabled = true
    }
    func disableRightButton() {
        rightButton.isEnabled = false
    }
 
}
