//
//  ImageFromPicker.swift
//  MumbaiPressApp
//
//  Created by user on 13/07/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation


extension UIImageView {
  
    
    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = false
        self.layer.rasterizationScale = UIScreen.main.scale
    }
}

extension DateFormatter{
    
    func changedate(strinTochan:String) ->String {
        let str = strinTochan.replacingOccurrences(of: "T", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    
    func datesetting (startdatetab:String) -> String {
        let startDate = changedate(strinTochan: startdatetab)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-ddHH:mm:ss"
        let formatedStartDate = dateFormatter.date(from: startDate)
        let currentDate = Date()
        let components = Set<Calendar.Component>([.year,.month,.day,.hour,.minute,.second])
        let differenceOfDate = Calendar.current.dateComponents(components, from: formatedStartDate!, to: currentDate)
        if differenceOfDate.year! > 0 {
            let formatednewDate = ("\(String(describing: differenceOfDate.year!)) year Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.month! > 0 && differenceOfDate.year! <= 0{
            let formatednewDate = ("\(String(describing: differenceOfDate.month!)) month Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.day! > 0 && differenceOfDate.month! <= 0 {
            let formatednewDate = ("\(String(describing: differenceOfDate.day!)) days Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.day! <= 0 && differenceOfDate.hour! > 0 {
            let formatednewDate = ("\(String(describing: differenceOfDate.hour!)) Hrs Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.day! <= 0 && differenceOfDate.hour! <= 0 && differenceOfDate.minute! > 0 {
            let formatednewDate = ("\(String(describing: differenceOfDate.minute!)) mins Ago")
            let newdate = formatednewDate
            return  newdate
        }
        if differenceOfDate.day! <= 0 && differenceOfDate.hour! <= 0 && differenceOfDate.minute! <= 0 && differenceOfDate.second! <= 60 {
            let formatednewDate = "Just now"
            let newdate = formatednewDate
            return  newdate
        }
        
        let formatednewDate = ("\(String(describing: differenceOfDate.day!))days")
        let newdate = formatednewDate
        return newdate
    }
    
}

extension UIView{
    func designCell()
    {
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.backgroundColor = UIColor.white
    }

}
extension Date {
    
    func getElapsedInterval() -> String {
        
        let interval = Calendar.current.dateComponents([.year, .month, .day], from: self, to: Date())
        
        if let year = interval.year, year > 0 {
            return year == 1 ? "\(year)" + " " + "year" :
                "\(year)" + " " + "years"
        } else if let month = interval.month, month > 0 {
            return month == 1 ? "\(month)" + " " + "month" :
                "\(month)" + " " + "months"
        } else if let day = interval.day, day > 0 {
            return day == 1 ? "\(day)" + " " + "day" :
                "\(day)" + " " + "days"
        } else {
            return "a moment ago"
            
        }
        
    }
}


