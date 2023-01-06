//
//  EditController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/22/22.
//

import UIKit
protocol AddNewTaskControllerDelegate: AnyObject {
    func addNewTaskControllerDelegate(_ controller: AddNewTaskController, text: String)
}
class AddNewTaskController: UIViewController {
    
    // MARK: - Properties
    weak var delegate: AddNewTaskControllerDelegate?
    
    var viewModel: AllCategoryViewModel! {
        didSet {
            self.borderColor = viewModel.backGroundColor
        }
    }
    private var borderColor: UIColor!
    
    private lazy var navigationView = NavigationView(title: "Add New", leftButtonImage: .xmarkCircleImage, rightString: "Add")
    
    private let textField = UITextField(placeHolder: "text...", textColor: .black)

    private let wordCountView = WordCountView(wordCount: "35")

    private let backGroundView = UIView()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureWordCounting(textField)
        navigationView.disableRightButton()
        textField.becomeFirstResponder()
        
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        
        view.isOpaque = true
        
        backGroundView.backgroundColor = .grayColor
        backGroundView.layer.cornerRadius = 20
        navigationView.delegate = self
        
        textField.delegate = self
        
        view.addSubview(backGroundView)
        backGroundView.setDemensions(height: view.frame.height/1.2,
                                     width: view.frame.width)
        
        backGroundView.centerX(inView: view,
                               bottomAnchor: view.bottomAnchor)
        
        navigationView.backgroundColor = .clear
        navigationView.layer.cornerRadius = 20
        
        view.addSubview(navigationView)
        navigationView.anchor(top: backGroundView.topAnchor,
                              left: backGroundView.leftAnchor,
                              right: backGroundView.rightAnchor,
                              paddingLeft: 0,
                              paddingRight: 0,
                              height: 66)
        
        
        textField.backgroundColor = .white
        view.addSubview(textField)
        textField.anchor(top: navigationView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, height: 51)
 

        view.addSubview(wordCountView)
        wordCountView.anchor(top: textField.bottomAnchor, right: textField.rightAnchor, paddingTop: 9, width: 120, height: 36)
        
        textField.addTarget(self, action: #selector(configureTextField), for: .editingChanged)
    }

    @objc func configureTextField(_ textField: UITextField) {
        configureWordCounting(textField)
    }
    func configureWordCounting(_ textField: UITextField) {
        Service.countingWordsTextField(textField, textLimit: 35) { wordCount in
            self.wordCountView.wordCountLabel.text = "\(wordCount)"
        }
      
    }
    func alertDelete() {
        
        let alert = UIAlertController(title: "", message: "Are you sure you want to delete this category?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { _ in
           // self.delegate?.editController(self)
            self.dismiss(animated: true)
        }))
        present(alert, animated: true)
    }
    
    func configureAddNewTask() {
        
  
        
    }
}

// MARK: - UITextFieldDelegate

extension AddNewTaskController: UITextFieldDelegate {
  
    func textFieldDidChangeSelection(_ textField: UITextField) {
        
        if textField.text?.isEmpty == false {
          
            navigationView.enableRightButton()

            if textField.text!.count > 35 {
                self.configureAlertMessage("You have reached maximum text")
                self.wordCountView.overMaximumWordCount()
                
            }else {
                self.wordCountView.underMaximumWordCount()
            }
        }else {
            self.navigationView.disableRightButton()
            
        }
    }
}
extension AddNewTaskController: NavigationViewDelegate {
  
    func navigationView(_ view: NavigationView, leftButton: UIButton) {
        dismiss(animated: true)
    }
    
    func navigationView(_ view: NavigationView, rightButton: UIButton) {
        
        guard let text = self.textField.text else {return}
        
        delegate?.addNewTaskControllerDelegate(self, text: text)
        
    }
    
}
