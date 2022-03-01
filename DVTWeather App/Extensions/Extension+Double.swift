//
//  Extension+Int.swift
//  DVTWeather App
//
//  Created by Lawrence Magerer on 27/02/2022.
//

import Foundation
extension Double {
    
    func getTime() -> String {
        let formatter = DateFormatter()
        let date = NSDate(timeIntervalSince1970: self)
        formatter.dateFormat = "HH:mm:ss"
        let timeString = formatter.string(from: date as Date)
        return timeString
    }

    func getDate() -> String {
        let formatter = DateFormatter()
        let date = NSDate(timeIntervalSince1970: self)
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: date as Date)
        return dateString
    }
    
    func getDateTime() -> String {
        let formatter = DateFormatter()
        let date = NSDate(timeIntervalSince1970: self)
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
        let dateString = formatter.string(from: date as Date)
        return dateString
    }

    func getDayOfWeek() -> String {
        let formatter = DateFormatter()
        let date = NSDate(timeIntervalSince1970: self)
        formatter.dateFormat = "EEEE"
        let dayOfTheWeek = formatter.string(from: date as Date)
        return dayOfTheWeek
    }
}
