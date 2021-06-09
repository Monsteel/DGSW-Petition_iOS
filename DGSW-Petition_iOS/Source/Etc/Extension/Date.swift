//
//  Date.swift
//  DGSW-Petition_iOS
//
//  Created by 이영은 on 2021/05/28.
//

import Foundation

extension Date {
    static func addDay(_ date: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: date, to: Date())!
    }
    
    func before(_ date: Date) -> Bool {
        return self < date
    }
    func after(_ date: Date) -> Bool {
        return self > date
    }
    
    func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }
    
    func add(_ year: Int = 0, month:Int = 0, day:Int = 0, hour:Int = 0, minute:Int = 0, second:Int = 0) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var dateComponents = DateComponents()
        dateComponents.year = self.year + year
        dateComponents.month = self.month + month
        dateComponents.day = self.day + day
        dateComponents.hour = self.hour + hour
        dateComponents.minute = self.minute + minute
        dateComponents.day = self.day + day
        dateComponents.second = self.second + second
        return calendar.date(from: dateComponents) ?? self
    }
    
    var month: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM"
        let month = Int(dateFormatter.string(from: self)) ?? 0
        return month
    }
    
    var year: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        let yaer = Int(dateFormatter.string(from: self)) ?? 0
        return yaer
    }
    
    var day: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd"
        let day = Int(dateFormatter.string(from: self)) ?? 0
        return day
    }
    
    var hour: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH"
        let day = Int(dateFormatter.string(from: self)) ?? 0
        return day
    }
    
    var minute: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm"
        let day = Int(dateFormatter.string(from: self)) ?? 0
        return day
    }
    
    var second: Int {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ss"
        let day = Int(dateFormatter.string(from: self)) ?? 0
        return day
    }
    
    func toString(format: String = "yyyy-MM-dd") -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = Locale(identifier: "ko")
        dateFormatter.amSymbol = "오전"
        dateFormatter.pmSymbol = "오후"
        
        return dateFormatter.string(from: self)
    }
    
    func equalsDate(date:Date) -> Bool{
        return (self.toString(format: "yyyyMMdd") == date.toString(format: "yyyyMMdd"))
    }
}

