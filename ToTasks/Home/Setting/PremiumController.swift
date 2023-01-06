//
//  PremiumController.swift
//  ToTasks
//
//  Created by Thenny Chhorn on 11/30/22.
//

import UIKit
import Foundation
import Alamofire
import StoreKit
import MessageUI

class PremiumController: UIViewController {
   
    private let productId = "thenny.com.ToTaskz.premium"

    // MARK: - Properties
    private let coverView = UIView()
    
    private let premiumView = PremiumPriceView()
    private lazy var navigationView = NavigationView(title: "Settings",
                                                     leftButtonImage: .xmarkCircleImage)

    private lazy var paymentMethodViewButton = SettingView(titleString: "Payment method",
                                                           iconImage: .creditCardImage!,
                                                             secondTitle: "Credit/debit card")
    
    private lazy var privacyPolicyView = SettingView(titleString: "Private policy",
                                                      iconImage: .verifyImage!)
    
    private lazy var ratingView = SettingView(titleString: "Rating",
                                                           iconImage: .starImage!)
    private lazy var sendEmailView = SettingView(titleString: "Email us",
                                                      iconImage: .sendImage!)
    private lazy var photoAccessView = SettingView(titleString: "Photo access",
                                                           iconImage: .permissionImage!)
    
    private lazy var notificationView = SettingView(titleString: "Notification",
                                                         iconImage: .notificationImage!)

    private let followCreatorView = FollowCreatorView()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .smallMedium
        label.minimumScaleFactor = 3
        label.numberOfLines = 0
        label.text = "Unliminted category cards\nSet reminder\nDownload category list"
        label.textAlignment = .left
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        navigationView.delegate = self
        premiumView.delegate = self
        
        SKPaymentQueue.default().add(self)
        
        notificationView.delegate = self
        photoAccessView.delegate = self
        ratingView.delegate = self
        sendEmailView.delegate = self
        privacyPolicyView.delegate = self
    
        followCreatorView.delegate = self
       
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        SKPaymentQueue.default().restoreCompletedTransactions()
        configurePremium()
    }
    
   
    // MARK: - Helpers
    
    func configureUI() {
        
        view.backgroundColor = .systemGroupedBackground 
        
        navigationView.backgroundColor = .clear
        navigationView.layer.cornerRadius = 20
        
        view.addSubview(navigationView)
        navigationView.anchor(top: view.topAnchor,
                              left: view.leftAnchor,
                              right: view.rightAnchor,
                              paddingLeft: 0,
                              paddingRight: 0,
                              height: 81)
    
        view.addSubview(premiumView)
        premiumView.anchor(top: navigationView.bottomAnchor,
                           left: view.leftAnchor,
                           right: view.rightAnchor,
                           paddingTop: 12,
                           paddingLeft: 20,
                           paddingRight: 20,
                           height: 150)
        
        let stackView = UIStackView(arrangedSubviews: [notificationView,
                                                       photoAccessView,
                                                       ratingView,
                                                       sendEmailView,
                                                       privacyPolicyView]).withAttributes(axis: .vertical, spacing: 6, distribution: .fillEqually)
        
        
        view.addSubview(stackView)
        stackView.anchor(top: premiumView.bottomAnchor,
                         left: view.leftAnchor,
                         bottom: view.safeAreaLayoutGuide.bottomAnchor,
                         right: view.rightAnchor,
                         paddingTop: 6,
                         paddingLeft: 20,
                         paddingBottom: 100,
                         paddingRight: 20)
    
        
        view.addSubview(followCreatorView)
        followCreatorView.anchor(left: view.leftAnchor,
                                 bottom: view.safeAreaLayoutGuide.bottomAnchor,
                                 right: view.rightAnchor,
                                 paddingBottom: 30,
                                 height: 45)
        
    }
 
    
    fileprivate func configurePremium() {
        if isPurchased() {
            premiumView.isPremiumAccount()
        }else {
            premiumView.notPremiumAccount()
        }
    }
 
    @objc func rateApp() {

        let appID = "1659953258"
        //  let urlStr = "https://itunes.apple.com/app/id\(appID)" // (Option 1) Open App Page
        let urlStr = "https://itunes.apple.com/app/id\(appID)?action=write-review" // (Option 2) Open App Review Page
        
        guard let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url) // openURL(_:) is deprecated from iOS 10.
        }
        
        
    }
}
// MARK: - NavigationViewDelegate

extension PremiumController: NavigationViewDelegate {
    
    func navigationView(_ view: NavigationView, leftButton: UIButton) {
        self.dismiss(animated: true)
    }
    
    func navigationView(_ view: NavigationView, rightButton: UIButton) {
        
    }
    
}

// MARK: - PremiumPriceViewDelegate

extension PremiumController: PremiumPriceViewDelegate {
   
    func premiumPriceView(_ viewWantsToBuy: PremiumPriceView) {
      
        configurePremium()
        
        premiumView.disableBuyButton()
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productId
            SKPaymentQueue.default().add(paymentRequest)
            
        }else {
            print("DEBUG: FAILED TO ADD PAYMENT")
           // self.coverView.removeFromSuperview()
        }
      
    }
    
    
}
extension PremiumController: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
      
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                print("DEBUG: USER HAS SUCCESSFULLY PURCHASED THIS APP")
                
                UserDefaults.standard.set(true, forKey: self.productId)
                self.premiumView.hideBuyButton()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }else if transaction.transactionState == .failed {
                self.configureAlertMessage("Purchase transaction was failed")
            }else if transaction.transactionState == .restored {
                
                UserDefaults.standard.set(true, forKey: self.productId)
                self.premiumView.isPremiumAccount()
                SKPaymentQueue.default().finishTransaction(transaction)
                
            }
        }
    }
 
}
// MARK: - SettingViewDelegate
extension PremiumController: SettingViewDelegate {
  
    func settingViewDelegate(_ settingView: SettingView) {
        
        switch settingView {
        case notificationView:
            print("DEBUG: NOTIFICATION BUTTON")
            let url = UIApplication.openNotificationSettingsURLString
            UIApplication.shared.open(URL(string: url)!)
            
        case photoAccessView:
            if let appSetting = URL(string: UIApplication.openSettingsURLString), UIApplication.shared.canOpenURL(appSetting) {
                UIApplication.shared.open(appSetting)
            }
        case ratingView:
            self.rateApp()
        case sendEmailView:
           let vc = EmailController()
            navigationController?.pushViewController(vc, animated: true)
        case privacyPolicyView:
            if let url = URL(string: "https://www.yellowcactus.dev/") {
                UIApplication.shared.open(url)
            }
        default:
            break
        }
        
    }
    
}
extension PremiumController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        print("EB DEBUG: ")
        print(result)
        controller.dismiss(animated: true)
        
    }
}
extension PremiumController: FollowCreatorViewDelegate {
    func followCreateView(_ view: FollowCreatorView, twitterString: String) {
        if let url = URL(string: twitterString) {
            UIApplication.shared.open(url)
        }
    }
    
    func followCreateView(_ view: FollowCreatorView, igTwitterString: String) {
        if let url = URL(string: igTwitterString) {
            UIApplication.shared.open(url)
        }
    }
    
}
