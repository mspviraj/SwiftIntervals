//
//  DateEnum.swift
//  TimeLapse
//
//  Created by Steven Smith on 1/6/17.
//  Copyright © 2017 LTMM. All rights reserved.
//

import Foundation

enum DateEnum {
    case since, now, until, between
    
    static func compareDate(_  from: Date, toDate: Date) -> DateEnum{
        switch(from.compare(toDate)) {
        case .orderedAscending:
            return .since
        case .orderedSame:
            return .now
        case .orderedDescending:
            return .until
        }
    }
}
