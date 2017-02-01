import Foundation

public enum Formats : String {
    static let wildCard = "*"

    case utc  = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
    case date = "yyyy-MMM-dd"
    case time = "h:mm:ss a z"
    case full = "yyyy-MMM-dd h:mm:ss a z"
}

enum DateEnum {
    case since
    case until
    case between
    case invalid
}

extension Date {
    public var utcString : String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Formats.utc.rawValue
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.string(from: self)
    }
    
    public func formatted(_ format: Formats, timeZone: TimeZone = TimeZone.autoupdatingCurrent) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = (format == .utc) ? TimeZone(secondsFromGMT: 0) : timeZone
        return dateFormatter.string(from: self)
    }
}

extension String {
    
    public func formatAs(_ type: Formats, withTimeZone: TimeZone = TimeZone.autoupdatingCurrent) -> String? {
        guard let date = self.asDate else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = type.rawValue
        dateFormatter.timeZone = (type == .utc) ? TimeZone(secondsFromGMT: 0) : withTimeZone
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

