import Foundation

extension Date {
    static func fromUTC(string: String) -> String? {
        guard let date = DateEnum.dateFrom(string: string) else {
            return nil
        }
        let localFormat = "dd-MMM-yyyy h:mm:ss a"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = localFormat
        dateFormatter.timeZone = TimeZone.current
        let x = dateFormatter.string(from: date)
        return x
    }
}

enum DateEnum {
    case since
    case until
    case between
    case invalid
    
    static let utcFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    
    static let dateWildCard = "*"
    
    static func stringFrom(date : Date?) -> String? {
        guard let date = date else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = utcFormat
        dateFormatter.timeZone = TimeZone.init(secondsFromGMT: 0)
        return dateFormatter.string(from: date)
    }
    
    static func dateFrom(string: String?) -> Date? {
        guard let string = string else {
            return nil
        }
        if string == dateWildCard {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = utcFormat
        return dateFormatter.date(from: string)
    }
    
    static func intervalType(firstDate: String, secondDate: String) -> DateEnum {
        guard let start = DateEnum.dateFrom(string: firstDate) else {
            assertionFailure("Invalid start date:\(firstDate)")
            return .invalid
        }
        
        guard let ending = DateEnum.dateFrom(string: secondDate) else {
            assertionFailure("Invalid ending date:\(secondDate)")
            return .invalid
        }
        
        if firstDate != dateWildCard && secondDate != dateWildCard {
            return .between
        }
        switch start.compare(ending) {
        case .orderedAscending:
            return .since
        case .orderedSame:
            assertionFailure("Identical dates")
            return .invalid
        case .orderedDescending:
            return .until
        }
    }
}
