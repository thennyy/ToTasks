//
//  ViewControllerExtension.swift
//  RednGreen
//
//  Created by Thenny Chhorn on 11/15/22.
//

import UIKit

extension UIViewController {
    
   
    func configureAlertMessage(_ textMessage: String) {
        let alert = UIAlertController(title: "", message: textMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .default))
        self.present(alert, animated: true)
        
    }
    func isPurchased() -> Bool {
        let productId = "thenny.com.ToTaskz.premium"
        let purchasedStatus = UserDefaults.standard.bool(forKey: productId)
        if purchasedStatus {
            print("Previouselty purchased")
            return true
        }else {
            print("Not purchased yest")
            return false
        }
    }
    func alertPurchasePremium() {
        
        let alert = UIAlertController(title: "Premium", message: "Unlock more features with one time purchase only $ 3.99", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        alert.addAction(UIAlertAction(title: "Purchase", style: .destructive, handler: { _ in
      
        }))
        present(alert, animated: true)
    }
    func alertLimiteAddCategory() {
        
        let alert = UIAlertController(title: "Premium", message: "You have reached category limites. Unlock more features with one time purchase only $ 3.99", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
        alert.addAction(UIAlertAction(title: "Purchase", style: .destructive, handler: { _ in
            
        }))
        present(alert, animated: true)
    }
}
