//
//  ExDateFormatter.swift
//  OYaar
//
//  Created by MB Infoways on 01/10/23.
//

import Foundation

extension Utilities {
    var displayTimeFormater: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = TimeZone.current
        return formatter
    }
    var displayDateFormater: DateFormatter {
        let displayDateFormater: DateFormatter = DateFormatter()
        displayDateFormater.dateFormat = "dd MMM yyyy"
        return displayDateFormater
    }
    var displayYearFormater: DateFormatter {
        let displayDateFormater: DateFormatter = DateFormatter()
        displayDateFormater.dateFormat = "yyyy"
        return displayDateFormater
    }
    var apiDateFormater: DateFormatter {
        let displayDateFormater: DateFormatter = DateFormatter()
        displayDateFormater.dateFormat = "yyyy-MM-dd"
        return displayDateFormater
    }
    var apiDateTimeFormater: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_IN")  // Add this line
        formatter.timeZone = TimeZone(secondsFromGMT: 0)  // Add this line
        return formatter
    }
    var apiDateTimeFormaterIST: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "en_IN")  // Add this line
        formatter.timeZone = TimeZone(abbreviation: "IST")  // Add this line
        return formatter
    }
}

func differenceBetweenDates(_ startDate: Date, _ endDate: Date) -> Int {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.day], from: startDate, to: endDate)
    return components.day ?? 0
}

func dateFromString(_ dateString: String, format: String = "dd MMM yyyy") -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.date(from: dateString)
}

func getCurrentDateFormatted(format: String = "dd MMM yyyy") -> String {
    let currentDate = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = format
    return dateFormatter.string(from: currentDate)
}

func displayString(inputDateStr: String, isShowTime: Bool = true) -> String {
    if let inputDate = Utilities().apiDateTimeFormater.date(from: inputDateStr) {
        let calendar = Calendar.current
        if calendar.isDateInToday(inputDate) {
            if isShowTime {
                return Utilities().displayTimeFormater.string(from: inputDate)
            } else {
                return "Today"
            }
            
        } else if calendar.isDateInYesterday(inputDate) {
            if isShowTime {
                return Utilities().displayTimeFormater.string(from: inputDate)
            } else {
                return "Yesterday"
            }
        } else {
            if isShowTime {
                return Utilities().displayTimeFormater.string(from: inputDate)
            } else {
                return Utilities().displayDateFormater.string(from: inputDate)
            }
        }
    } else {
        return "Invalid Date"
    }
}
