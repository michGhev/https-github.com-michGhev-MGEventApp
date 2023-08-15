//
//  AddEventVM.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 14.08.23.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift


class EventsVM {
    
    // MARK: - Private properties -
    
    private let eventsList: BehaviorRelay<[EventModel]> = BehaviorRelay(value: [])
    private var dates: BehaviorRelay<[DateComponents]> = BehaviorRelay(value: [])
    
    // MARK: - Get events list -
    
    func getEventList() -> BehaviorRelay<[EventModel]>  {
        return eventsList
    }
    
    func getEventByIndex(_ index: Int) -> EventModel {
        return eventsList.value[index]
    }
    
    // MARK: - Get dates list -

    func getDatesList() -> BehaviorRelay<[DateComponents]> {
        return dates
    }
    
    // MARK: - Get data -
    
    func uploadEvents() {
        do {
            let realm = try Realm()
            let events = realm.objects(EventModelRealm.self)
            if(!events.isEmpty) {
                var data: [EventModel] = []
                var dateList: [DateComponents] = []
                for event in events {
                    let eventModel = EventModel(id: event.id, date: event.date, time: event.time, title: event.title)
                    data.append(eventModel)
                    if let date = Constants.Formatters.ddMMMyyyy.date(from: event.date) {
                        let dateComponents = Calendar.current.dateComponents([.month,.day,.year], from: date)
                        dateList.append(dateComponents)
                    } else {
                        print("There was an error decoding the string")
                    }
                }
                self.dates.accept(dateList)
                self.eventsList.accept(data)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
