//
//  Service.swift
//  RednGreen
//
//  Created by Thenny Chhorn on 11/11/22.
//

import UIKit
import StripePaymentSheet
import Firebase
import ProgressHUD

struct Service {
    
    static func showProgress() {
        
        ProgressHUD.colorAnimation = .orangeColor
        ProgressHUD.showSucceed()
        
    }
    static func sendEmail(_ sendEmail: SendEmail, completion: @escaping(Error?) -> Void) {
        let data = ["emailText": sendEmail.emailText,
                    "sender": sendEmail.sender,
                    "time": sendEmail.date] as [String : Any]
      
        let firestore = Firestore.firestore().collection("emails")
       // let id = firestore.collectionID
        let date = sendEmail.date.dateInString(date: Date())
        firestore.document(date).setData(data, completion: completion)
        
    }
    static func acceptPayment() {
        
    }
    
    static func getJSONFile(forName name: String, completion: @escaping([IconModel]) -> Void) {
       
        var iconModels = [IconModel]()
        
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {return}
        
        do {
            let jsonString = try String(contentsOfFile: path, encoding: .utf8)
            let jsonData: Data = jsonString.data(using: .utf8)!
            let images = try JSONDecoder().decode([Image].self, from: jsonData)
            
            for index in 0...images.count - 1 {
                var iconModel = IconModel(name: images[index].name,
                                          group: images[index].group)
                
                if iconModel.group == "communication" {
                    iconModel.communication.append(iconModel.name)
                }
                if iconModel.group == "weather" {
                    iconModel.weather.append(iconModel.name)
                }
                if iconModel.group == "human" {
                    iconModel.human.append(iconModel.name)
                }
                if iconModel.group == "object" {
                    iconModel.object.append(iconModel.name)
                }
                
                iconModels.append(iconModel)
            }
            
            completion(iconModels)
            
        } catch {
            print(error)
        }
        
    }
    static func downloadImage(image: UIImage) {
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
    }

    func fetchIconImages(images: [Image], completion: @escaping([IconModel]) -> Void) {
       
        
      
    }
    static func countingWordsTextField(_ textField: UITextField, textLimit: Int, completion: @escaping(String) -> Void) {
            if textField.text?.isEmpty == false {
                if let count = textField.text?.count {
                    if count > 0 {
                        let wordCount = textLimit - count
                        completion(String(wordCount))
                    }
                }
            }else {
                completion(String(textLimit))
            }
    }
    static func countingWordsTextView(_ textView: UITextView,completion: @escaping(String) -> Void) {
            if textView.text?.isEmpty == false {
                if let count = textView.text?.count {
                    if count > 0 {
                        let wordCount = 200 - count
                        completion(String(wordCount))
                    }
                }
            }else {
                completion(String(200))
            }
    }
    static func converCategoryColor(colorName: String,
                                    completion: @escaping(UIColor) ->Void) {
        
        switch colorName {
        case "orangeColor":
            completion(UIColor.orangeColor)
        case "yellowColor":
            completion(UIColor.yellowColor)
        case "pinkColor":
            completion(UIColor.pinkColor)
        case "blueColor":
            completion(UIColor.blueColor)
        case "greenColor":
            completion(UIColor.greenColor)
        case "lavenderColor":
            completion(UIColor.lavenderColor)
        case "tealColor":
            completion(UIColor.tealColor)
        default:
            completion(UIColor.orangeColor)
        }
    }
    static func setDateReminder(_ selectedDate: Date,  category: Category) {
            
        let current = UNUserNotificationCenter.current()
        current.requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                
                Service.scheduleDate(selectedDate, category: category)
                
            } else if let error = error {
                print("DEBUG: ERROR WHILE ", error.localizedDescription)
                
            }
           
        }
    }
    static func scheduleDate(_ selectedDate: Date, category: Category) {
        
        let content = UNMutableNotificationContent()
        content.title = category.name ?? "ToTasks"
        content.sound = .default
        let targetDate = selectedDate
        let triggerCalendar = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: targetDate), repeats: false)
        let request = UNNotificationRequest(identifier: "some_id", content: content, trigger: triggerCalendar)
        
        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("DEBUG: NOTIFICATION WENT WRONG")
            }
            print("DEBUG: SUCCESSFULLY")
        }
    }
}
