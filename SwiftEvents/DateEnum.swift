import Foundation

    fileprivate enum Formats {
        static let utc  = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        static let date = "yyyy-MMM-dd"
        static let time = "h:mm:ss a z"
        static let full = "yyyy-MMM-dd h:mm:ss a z"
    }

extension Date {
    static func fromUTC(string: String) -> String? {
        guard let date = DateEnum.dateFrom(string: string) else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = localFormat
        dateFormatter.timeZone = TimeZone.current
        let x = dateFormatter.string(from: date)
        return x
    }
    
    public var utcString : String {
    }
    
    public func asString(format: String = Formats.utc, timeZone: TimeZone = TimeZone.init(secondsFromGMT: 0)) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Formats.utc
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(form: self)
    }
}

extension String {
    
    public func display(_ timeZone : TimeZone = TimeZone.current, format: String = Formats.full) -> String? {
        guard let date = self.asDate else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
    
    public var asDate : Date? {
        if self == "*" {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Formats.utc
        if let formatted = dateFormatter.date(from: self) {
            return formatted
        }
        dateFormatter.dateFormat = Formats.full
        return dateFormatter.date(from: self)
    }
}

enum DateEnum {
    case since
    case until
    case between
    case invalid
    
    static let utcFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static let dateFormat = "yyyy-MMM-dd"
    static let timeFormat = "h:mm:ss a z"
    
    
    static let dateWildCard = "*"
    
    static func display(_ date : Date? = Date(),
                        format: String = dateFormat + " " + timeFormat,
                        timeZone: TimeZone = TimeZone.current) -> (String?, TimeZone) {
        guard let date = date else {
            return (nil, timeZone)
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return (dateFormatter.string(from: date), timeZone)
    }
    
    static func displayTime(_ date : Date? = Date(),
                            timeZone: TimeZone = TimeZone.current) -> (caption: String?, timeZone: TimeZone) {
        return display(date, format: timeFormat, timeZone: timeZone)
    }
    
    static func displayDate(_ date : Date? = Date(),
                            timeZone: TimeZone = TimeZone.current) -> (caption: String?, timeZone: TimeZone) {
        return display(date, format: dateFormat, timeZone: timeZone)
    }
    
    
    
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
