//
//  TimePickerView.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/2/22.
//

import UIKit
protocol TimePickerViewDelegate: AnyObject {
    func timePickerView(_ closeButtoN: UIButton, selectedTime: String)
}
class TimePickerView: UIView {
    
    weak var delegate: TimePickerViewDelegate?
    
    private let pickerView = UIPickerView()
    
    private var selectedTime: String!
    
    private let thirdpickerArray = ["AM", "PM"]
    private let firstPickerArray = ["12","1","2","3","4","5","6","7","8","9","10","11"]
    private let secondPickerArray = ["00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15","16","17","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37","38","39","40","41","42","43","44","45","46","47","48","49","50","51","52","53","54","55","56","57","58","59"]
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
       // button.translatesAutoresizingMaskIntoConstraints = false
       button.setImage(.downArrowImage, for: .normal)
        button.setDemensions(height: 36, width: 36)
       // button.imageView?.contentMode = .scaleToFill
       // button.clipsToBounds = true
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 12
        
        pickerView.delegate = self
        pickerView.dataSource = self
        
        pickerView.tintColor = .white
        addSubview(pickerView)
        pickerView.anchor(top: topAnchor,
                          left: leftAnchor,
                          bottom: bottomAnchor,
                          right: rightAnchor,
                          paddingTop: 30,
                          paddingLeft: 40,
                          paddingBottom: 20,
                          paddingRight: 40)
        
        
        addSubview(closeButton)
        closeButton.anchor(top: topAnchor,
                           right: rightAnchor,
                           paddingTop: 6,
                           paddingRight: 6)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleCloseButton(_ sender: UIButton) {
        delegate?.timePickerView(sender, selectedTime: selectedTime)
    }
}
extension TimePickerView: UIPickerViewDelegate, UIPickerViewDataSource, UINavigationControllerDelegate {
  
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        switch component {
        case 0:
            return firstPickerArray.count
        case 1:
            return secondPickerArray.count
        case 2:
            return thirdpickerArray.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch component {
        case 0:
            return firstPickerArray[row]
        case 1:
            return secondPickerArray[row]
        case 2:
            return thirdpickerArray[row]
        default:
            return ""
        }
      
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedTime = firstPickerArray[row] + " "  + secondPickerArray[row] + " " + thirdpickerArray[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 54
        
    }

    
}
