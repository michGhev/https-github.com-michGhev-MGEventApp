//
//  EventModel.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 14.08.23.
//

import Foundation
import RealmSwift


struct EventModel {
    var id: ObjectId?
    var date: String
    var time: String
    var title: String
}

class EventModelRealm: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var date: String
    @Persisted var time: String
    @Persisted var title: String
}
