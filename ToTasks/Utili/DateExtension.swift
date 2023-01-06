//
//  DateExtension.swift
//  EnterAct_TEST
//
//  Created by Thenny Chhorn on 10/19/21.
//

import UIKit

extension Date {
    
    func timeAgoDisplay() -> String {
        
      //  let secondsAgo = Int(Date().timeIntervalSince(self))
        let timesAgo = Date().timeIntervalSince(self)
        let secondsAgo = Int(timesAgo)
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        let month = 4 * week
        
        var returnValue: String
        
        var quotient: Int
        let unit: String
       
        if secondsAgo < minute {
            quotient = secondsAgo
                   if quotient == 0 {
                       quotient = 1
                   }
            
            unit = "second"
            returnValue = "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        } else if secondsAgo < hour {
            quotient = secondsAgo / minute
                   if quotient == 0 {
                       quotient = 1
                   }
            
            unit = "minute"
            returnValue = "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        } else if secondsAgo < day {
            quotient = secondsAgo / hour
                   if quotient == 0 {
                       quotient = 1
                   }
            
            unit = "hour"
            returnValue = "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        } else if secondsAgo < week {
            quotient = secondsAgo / day
            unit = "day"
                   if quotient == 0 {
                       quotient = 1
                   }
            
            returnValue = "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
            
        } else if secondsAgo < month {
            
            quotient = secondsAgo / week
            unit = "week"
                   if quotient == 0 {
                       quotient = 1
                   }
            
            returnValue = "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
            
        } else {
            quotient = secondsAgo / month
            unit = "month"
            if quotient == 0 {
                quotient = 1
            }
            returnValue = "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        }/*else {
            
            quotient = secondsAgo
            let date = Date(timeIntervalSince1970: timesAgo)
            let dateFormate = DateFormatter()
            dateFormate.timeZone = TimeZone(abbreviation: "GMT")
            dateFormate.locale = NSLocale.current
            dateFormate.dateFormat = "MM-dd-YYYY HH:mm"
            let setDate = dateFormate.string(from: date)
           
            returnValue = setDate
            
        }*/
        /*if quotient == 0 {
            quotient = 1
        }*/
     
   
       // return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
        return returnValue
        
    }
}

extension Date {
    
    func dateInString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
       return formatter.string(from: date)
        
    }
    func dateShortString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        return formatter.string(from: date)
    }
    func timeInString(date: Date) -> String {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        return  formatter.string(from: date)
    }
}
