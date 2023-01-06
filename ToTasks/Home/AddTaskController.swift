//
//  AddTaskController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/28/22.
//

import UIKit

class AddTaskController: UIViewController {
    
    var viewModel: AllCategoryViewModel! {
        didSet {
            self.borderColor = viewModel.backGroundColor
        }
    }
    private var borderColor: UIColor!
    private let backGroundView = UIView()
  
    private lazy var addTaskButton = EditButton(title: "Add task",
                                                titleColor: .black,
                                                radius: 12,background: borderColor,
                                                 borderWidth: 2,borderColor: .gray)
    
    
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(.xmarkCircleImage, for: .normal)
        button.tintColor = .black
        button.setDemensions(height: 30, width: 30)
        button.addTarget(self, action: #selector(handleCloseButton),
                         for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    @objc func handleCloseButton() {
        self.dismiss(animated: true)
    }
    
    func configureUI() {
        
        view.isOpaque = true
        
        backGroundView.backgroundColor = .grayColor
        backGroundView.layer.cornerRadius = 20
        
        view.addSubview(backGroundView)
        backGroundView.setDemensions(height: view.frame.height - 100,
                                     width: view.frame.width - 20)
        
        
        backGroundView.centerY(inView: view)
        
        
        view.addSubview(closeButton)
        closeButton.anchor(top: backGroundView.topAnchor,
                           right: backGroundView.rightAnchor,
                           paddingTop: 6,
                           paddingRight: 6)
        
    }
}
