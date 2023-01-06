//
//  DatePickerView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/1/22.
//

import UIKit
import Foundation

protocol SetDateViewDelegate: AnyObject {
    func setDateView(_ dismissLeftButton: UIButton)
    func setDateViewRight(_ selectedDate: Date)
    func setDateTimer()
}
class SetDateView: UIView {
    

    weak var delegate: SetDateViewDelegate?
    
    
    private lazy var navigationView = NavigationView(title: "Calendar",
                                                     leftButtonImage: .xmarkCircleImage,
                                                     rightString: "Done")
    private lazy var datePickerView: UIDatePicker = {
     
        let picker = UIDatePicker()
      // picker.translatesAutoresizingMaskIntoConstraints = false
        picker.datePickerMode = .dateAndTime
        picker.preferredDatePickerStyle = .inline
        picker.tintColor = .orangeColor
        picker.clipsToBounds = true
        return picker
    }()
    
    private lazy var timeButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .orangeColor
        button.titleLabel?.font = .regularMedium
        button.backgroundColor = .barDeselectedColor
        button.setTitle("12:00 AM", for: .normal)
        button.setWidth(width: 120)
        button.layer.cornerRadius = 9
        button.addTarget(self, action: #selector(setTimer), for: .touchUpInside)
        return button
    }()
    private let timeTitle: UILabel = {
        let label = UILabel()
        label.font = .regularMedium
        label.textColor = .darkGray
        label.textAlignment = .right
        label.text = "Set time"
        return label
    }()

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .grayColor 
        
        navigationView.delegate = self
        navigationView.backgroundColor = .clear
       
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        
        backgroundColor = .grayColor
        layer.borderColor = UIColor.orangeColor.cgColor
        layer.borderWidth = 3
        layer.cornerRadius = 15
                
        addSubview(navigationView)
        navigationView.anchor(top: topAnchor,
                              left: leftAnchor,
                              right: rightAnchor,
                              paddingTop: 9,
                              height: 60)
            
        addSubview(datePickerView)
        datePickerView.anchor(top: navigationView.bottomAnchor,
                            left: leftAnchor,
                            bottom: bottomAnchor,
                            right: rightAnchor,
                            paddingTop: 9,
                            paddingLeft: 9,
                            paddingBottom: 30,
                            paddingRight: 9)
        
    }
    @objc func setTimer(_ sender: UIButton) {
        
        delegate?.setDateTimer()
        
    }
}
extension SetDateView: UICalendarSelectionSingleDateDelegate {
   
    func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        
        let dateSelected = datePickerView.date
        let timeSelec = Date().timeInString(date: dateComponents?.date ?? Date())
        
        print(dateSelected)
        print(timeSelec)
        
        navigationView.enableRightButton()
        
        timeButton.setTitle("\(timeSelec)", for: .normal)
        timeButton.layer.borderWidth = 1
        timeButton.layer.borderColor = UIColor.orangeColor.cgColor
        timeButton.backgroundColor = .white
        
        delegate?.setDateViewRight(dateSelected)
        
    }
    
}
extension SetDateView: NavigationViewDelegate {
    func navigationView(_ view: NavigationView, leftButton: UIButton) {
        delegate?.setDateView(leftButton)
    }
    
    func navigationView(_ view: NavigationView, rightButton: UIButton) {
        delegate?.setDateTimer()
        
        let dateSelected = datePickerView.date
 
        print(dateSelected)
  
       // navigationView.enableRightButton()
        timeButton.layer.borderWidth = 1
        timeButton.layer.borderColor = UIColor.orangeColor.cgColor
        timeButton.backgroundColor = .white
        
        delegate?.setDateViewRight(datePickerView.date)
        
    }
    
    
}
