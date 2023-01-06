//
//  SetReminderController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/1/22.
//

import UIKit
import UserNotifications

protocol SetReminderControllerDelegate: AnyObject {
    func setReminderController(_ controller: SetReminderController, selectedTime: Date)
}
class SetReminderController: UIViewController {
    
    // MARK: - Properties
    var cateogry: Category!
    
    weak var delegate: SetReminderControllerDelegate?
    
    private let calenderView = SetDateView()
    private let timePickerView = TimePickerView()
        
    private lazy var navigationView = NavigationView(title: "Calendar",
                                                     leftButtonImage: .xmarkCircleImage,
                                                     rightString: "Done")
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
    }
    
    func configureUI() {
        
        calenderView.delegate = self
        timePickerView.delegate = self
        
        view.isOpaque = true
        
        view.addSubview(calenderView)
        calenderView.anchor(left: view.leftAnchor,
                            bottom: view.bottomAnchor,
                            right: view.rightAnchor,
                            height: view.frame.height/1.5)
   
    }
}
extension SetReminderController: SetDateViewDelegate {
    func setDateTimer() {
        
    }
    
    func setDateView(_ dismissLeftButton: UIButton) {
        self.dismiss(animated: true)
    }
    
    func setDateViewRight(_ selectedDate: Date) {
      
      //  Service.setDateReminder(selectedDate, category: self.cateogry)
        delegate?.setReminderController(self, selectedTime: selectedDate)
        self.dismiss(animated: true)
        
    }
 
    func scheduleDate(_ selectedDate: Date) {
        
       
        
    }
    

}
extension SetReminderController: TimePickerViewDelegate {
  
    func timePickerView(_ closeButtoN: UIButton, selectedTime: String) {
        timePickerView.removeFromSuperview()
    }
    
    
}
