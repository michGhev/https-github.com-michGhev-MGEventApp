//
//  AddEventVM.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 15.08.23.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa


class AddEventVM {
    
    //MARK: - Properties -
    
    var uploadIsSucces: PublishRelay<Bool> = PublishRelay()
    
    //MARK: - func add event to Realm DB -
    
    func uploadToRealm(model: EventModel) {
        do {
            let realm = try Realm()
            let modelRealm = EventModelRealm()
            modelRealm.time = model.time
            modelRealm.date = model.date
            modelRealm.title = model.title
            try realm.write {
                realm.add(modelRealm)
                uploadIsSucces.accept(true)
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    //MARK: - func update event to Realm DB -

    func updateToRealm(model: EventModel) {
        do {
            let realm = try Realm()
            let results = realm.objects(EventModelRealm.self).filter("id == %@", model.id!)
            if let modelRealm = results.first {
                try! realm.write {
                    modelRealm.title = model.title
                    modelRealm.time = model.time
                    modelRealm.date = model.date
                    uploadIsSucces.accept(true)
                }
            }
        } catch let error {
            print(error.localizedDescription)
        }
    }
}
