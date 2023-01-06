//
//  PremiumView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/22/22.
//

import UIKit
protocol ReminderViewDelegate: AnyObject {
    func reminderViewDelegate(_ viewToSetPremium: ReminderView)
    func reminderView(_ addDateButton: UIButton)
    func reminderViewAddTime(_ addTimeButton: UIButton)
    
}
class ReminderView: UIView {
    
    private let backGroundView = UIView()
    
    weak var delegate: ReminderViewDelegate?
    

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .regularBold
        label.textColor = .darkGray
        
        return label
    }()
    private lazy var switchButton: UISwitch = {
        let switchButton = UISwitch()
        switchButton.onTintColor = .systemBlue
        switchButton.addTarget(self, action: #selector(handleSwitchButtonControl), for: .valueChanged)
       // switchButton.thumbTintColor = .systemBlue
       // switchButton.setDemensions(height: 30, width: 90)
        return switchButton
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .smallMedium
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Date"
        return label
    }()
    private lazy var dateButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .smallMedium
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .barDeselectedColor
        button.setTitle("Nov-30-2022", for: .normal)
        button.layer.cornerRadius = 9
        button.setDemensions(height: 42, width: 150)
        button.addTarget(self, action: #selector(handleDateButton), for: .touchUpInside)
        return button
    }()
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = .smallMedium
        label.textColor = .darkGray
        label.numberOfLines = 0
        label.text = "Time"
        return label
    }()
    private lazy var timeButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .smallMedium
        button.setTitleColor(.gray, for: .normal)
        button.backgroundColor = .barDeselectedColor
        button.setTitle("12:00 AM", for: .normal)
        button.layer.cornerRadius = 9
        button.setDemensions(height: 42, width: 111)
        button.addTarget(self, action: #selector(handleTimeButton), for: .touchUpInside)
        return button
    }()
    private let premiumImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.image = .crownFillImage
        iv.setDemensions(height: 30, width: 30)
        iv.tintColor = .yellowColor
        
        return iv
    }()
    private lazy var rightArrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.forwardImage, for: .normal)
        button.tintColor = .darkGray

        button.clipsToBounds = true
        button.setDemensions(height: 30, width: 30)
        return button
    }()
  
    convenience init(title: String) {
        self.init()
        
        backgroundColor = .orangeColor
        layer.cornerRadius = 15
        titleLabel.text = title
      //  secondtitleLabel.text = secondTitle
        
        backGroundView.backgroundColor = .shareWhiteColor
        backGroundView.layer.cornerRadius = 15
        
        addSubview(backGroundView)
  
        backGroundView.anchor(top: topAnchor,
                              left: leftAnchor,
                              bottom: bottomAnchor,
                              right: rightAnchor,
                              paddingTop: 1,
                              paddingLeft: 1,
                              paddingBottom: 1,
                              paddingRight: 1)
        
        
        let stackview = UIStackView(arrangedSubviews: [titleLabel,
                                                       premiumImage]).withAttributes(axis: .horizontal, spacing: 9, distribution: .fill)
        
        addSubview(stackview)
        stackview.anchor(top: topAnchor,
                         left: leftAnchor,
                         paddingTop: 20,
                         paddingLeft: 20)
        
        addSubview(switchButton)
        switchButton.centerY(inView: stackview,
                             rightAnchor: rightAnchor,
                             paddingRight: 20)
    
        let date = Date().dateShortString(date: Date())
        dateButton.setTitle(date, for: .normal)
        
        addSubview(dateButton)
        dateButton.anchor(left: leftAnchor,
                          bottom: bottomAnchor,
                          paddingLeft: 20,
                          paddingBottom: 20)
        
        addSubview(dateLabel)
        dateLabel.anchor(left: dateButton.leftAnchor, bottom: dateButton.topAnchor, paddingBottom: 9)
        
        addSubview(timeButton)
    
        timeButton.centerY(inView: dateButton,
                           rightAnchor: rightAnchor,
                          paddingRight: 20)
        
        addSubview(timeLabel)
        timeLabel.anchor(left: timeButton.leftAnchor,
                         bottom: timeButton.topAnchor,
                         paddingBottom: 9)
        

    }
    @objc func handleSwitchButtonControl() {
        print("DEBUG: SWITCH BUTTON")
        DataManager.shared.checkPremiumUser { isPremium in
            if isPremium == false {
                self.switchButton.isOn = false
            }
        }
        delegate?.reminderViewDelegate(self)
        
    }
    @objc func handleDateButton(_ sender: UIButton) {
        delegate?.reminderView(sender)
    }
    @objc func handleTimeButton(_ sender: UIButton) {
        delegate?.reminderViewAddTime(sender)
        
    }
    func setCalendar(dateString: String) {
        dateButton.setTitle(dateString, for: .normal)
        
    }
}
