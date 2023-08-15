//
//  Constants.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 15.08.23.
//

import Foundation


enum NavigationBarName {
    static let events = "Events Calendar"
    static let addEvent = "New Event"
}

struct Constants {
    enum Formatters {
        static var ddMMMyyyy: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "dd MMM yyyy"
            return formatter
        }()
    }
}
