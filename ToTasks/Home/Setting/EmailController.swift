//
//  EmailController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 12/15/22.
//

import UIKit
import MessageUI

class EmailController: UIViewController {
    
    // MARK: - Properties
    private lazy var navigationView = NavigationView(title: "Write Email",
                                                     leftButtonImage: .backImage,
                                                     rightString: "Send",
                                                     rightButtonColor: .orangeColor)
    
    private lazy var emailTextField = UITextField(placeHolder: "email@email.com",
                                                  textColor: .systemBlue)
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .regularMedium
        label.text = "Send Email"
        return label
    }()
    private lazy var emailTextView: CustomTextView = {
        let tv = CustomTextView()
        tv.font = .regularMedium
        tv.textColor = .black
        tv.backgroundColor = .grayColor
        tv.layer.cornerRadius = 9
        tv.delegate = self
        
        return tv
    }()
    
    private let wordCountView = WordCountView(wordCount: "200")
    
    private lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.regularMedium
        button.tintColor = .orangeColor
        button.setTitle("Send", for: .normal)
        
        return button
    }()
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        navigationView.delegate = self
        navigationView.disableRightButton()
        emailTextField.becomeFirstResponder()
        
        configureTextViewCount(emailTextView)
        emailTextField.delegate = self
        emailTextField.keyboardType = .emailAddress
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        emailTextView.resignFirstResponder()
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    fileprivate func configureTextViewCount(_ textView: UITextView) {
        Service.countingWordsTextView(textView) { count in
            self.wordCountView.wordCountLabel.text = "\(count)"
        }
    }
    
    // MARK: - Helper
    fileprivate func configureUI() {
        
        view.backgroundColor = .systemGroupedBackground 
        
        navigationController?.navigationItem.titleView = titleLabel
        
        view.addSubview(navigationView)
        navigationView.anchor(top: view.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              height: 72)
        
        emailTextField.backgroundColor = .grayColor
        
        view.addSubview(emailTextField)
        emailTextField.anchor(top: navigationView.bottomAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingTop: 9,
                              paddingLeft: 20,
                              paddingRight: 20, height: 42)
        
        view.addSubview(emailTextView)
        emailTextView.anchor(top: emailTextField.bottomAnchor,
                             left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 9,
                             paddingLeft: 20,
                             paddingRight: 20,
                             height: 200)
        
        view.addSubview(wordCountView)
        wordCountView.anchor(top: emailTextView.bottomAnchor,
                             right: emailTextView.rightAnchor, paddingTop: 9)
        
        
    }
    
}
// MARK: - NavigationViewDelegate

extension EmailController: NavigationViewDelegate {
   
    func navigationView(_ view: NavigationView, leftButton: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    func navigationView(_ view: NavigationView, rightButton: UIButton) {
      
        if emailTextField.text?.isEmpty == true {
            configureAlertMessage("Please check email field")
        }else {
            guard let emailText = emailTextField.text else {return}
            
            if  validateEmail(enteredEmail: emailText) {
                
                guard let emailText = self.emailTextView.text, let emailID = emailTextField.text else {return}
                Service.sendEmail(SendEmail(sender: emailID, emailText: emailText, date: Date())) { error in
                    if let error = error {
                        print("DEBUG: ERROR SENDING EMAIL", error.localizedDescription)
                        return
                    }
                    self.sendEmailSuccessfully()
                   
                }
    
                
            }else {
                configureAlertMessage("Please check email field")
            }
        }
    }
    func validateEmail(enteredEmail:String) -> Bool {

        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)

    }
    func sendEmailSuccessfully() {

        Service.showProgress()
        
        navigationView.disableRightButton()
        emailTextView.text = ""
        emailTextField.text = ""
        emailTextView.resignFirstResponder()
        emailTextField.resignFirstResponder()
        wordCountView.wordCountLabel.text = "200"
    }
    
}
// MARK: - UITextFieldDelegate
extension EmailController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if emailTextView.text.isEmpty != true {
            navigationView.enableRightButton()
        }else {
            navigationView.disableRightButton()
        }
    }
}
// MARK: - UITextViewDelegate
extension EmailController: UITextViewDelegate {
   
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty  {
            navigationView.disableRightButton()
            wordCountView.wordCountLabel.text = "200"
        }else {
            
            navigationView.enableRightButton()
            
            if textView.text!.count <= 200 {
                Service.countingWordsTextView(textView) { wordCount in
                    self.wordCountView.wordCountLabel.text = wordCount
                    self.wordCountView.underMaximumWordCount()
                }
               
            }else {
                self.configureAlertMessage("You have reached maximum text")
                self.wordCountView.overMaximumWordCount()
      
            }
        }
    }
}
