import Foundation

public enum Formats : String {
    static let wildCard = "*"

    case utc  = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    case date = "yyyy-MMM-dd"
    case time = "h:mm:ss a z"
    case full = "yyyy-MMM-dd h:mm:ss a z"
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
    public var utcString : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Formats.utc.rawValue
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: self)
    }
    
    public func format(_ format: Formats = Formats.utc, timeZone: TimeZone = TimeZone(secondsFromGMT: 0)!) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    public func formatAs(_ type: Formats, withTimeZone: TimeZone = TimeZone.autoupdatingCurrent) -> String? {
        guard let date = self.asDate else {
            return nil
        }
        let timeZone = (type == .utc) ? TimeZone(secondsFromGMT: 0) : withTimeZone
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = timeZone
        return dateFormatter.string(from: date)
    }
    
    public func formatAs(_ type: Formats, withTimeZone: String) -> String? {
        guard let timeZone = withTimeZone.asTimeZone else {
            return nil
        }
        return formatAs(type, withTimeZone: timeZone)
    }
    
    public var asDate : Date? {
        if self == Formats.wildCard {
            return Date()
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Formats.utc.rawValue
        if let formatted = dateFormatter.date(from: self) {
            return formatted
        }
        dateFormatter.dateFormat = Formats.full.rawValue
        return dateFormatter.date(from: self)
    }
    
    public var rawDate : String? {
        return (self == Formats.wildCard) ? Formats.wildCard : self.asDate?.utcString
    }
    
    public var asTimeZone : TimeZone? {
        if let timeZone = TimeZone(abbreviation: self) {
            return timeZone
        }
        if let timeZone = TimeZone(identifier: self) {
            return timeZone
        }
        return nil
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
