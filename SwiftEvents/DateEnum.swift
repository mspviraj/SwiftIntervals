import Foundation

public enum Formats {
    static let utc  = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    static let date = "yyyy-MMM-dd"
    static let time = "h:mm:ss a z"
    static let full = "yyyy-MMM-dd h:mm:ss a z"
    static let wildCard = "*"
}

extension TimeZone {
    public var asString : String {
        return TimeZone.current.abbreviation() ?? "UTC"
    }
    
    public static func from(abbreviation: String) -> TimeZone {
        return TimeZone(abbreviation: abbreviation) ?? TimeZone(secondsFromGMT: 0)!
    }
}

extension Date {
//    static func fromUTC(string: String) -> String? {
//        guard let date = DateEnum.dateFrom(string: string) else {
//            return nil
//        }
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = Formats.utc
//        dateFormatter.timeZone = TimeZone.current
//        let x = dateFormatter.string(from: date)
//        return x
//    }
//    
    public var utcString : String {
        return asString()!
    }
    
    public func asString(format: String = Formats.utc, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    public func display(timeZoneString: String = "UTC", format: String = Formats.full) -> String {
        if let timeZone = timeZoneString.asTimeZone, self.asDate != nil {
            return display(timeZone: timeZone, format: format)!
        }
        return NSLocalizedString("Not date String", comment: "Cant format this kind of string")
    }
    
    public func display(timeZone: TimeZone = TimeZone.current, format: String = Formats.full) -> String? {
        guard let date = self.asDate else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
    
    public var asDate : Date? {
        if self == Formats.wildCard {
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
    
    public var rawDate : String? {
        return (self == Formats.wildCard) ? Formats.wildCard : self.asDate?.utcString
    }
    
    public var asTimeZone : TimeZone? {
        return TimeZone(abbreviation: self)
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
        if string == Formats.wildCard {
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
        
        if firstDate != Formats.wildCard && secondDate != Formats.wildCard {
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
