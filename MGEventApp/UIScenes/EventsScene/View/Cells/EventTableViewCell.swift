//
//  EventTableViewCell.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 14.08.23.
//

import UIKit
import RealmSwift


class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    private var model: EventModel!

    func getModel() -> EventModel {
        return model
    }

    func setCell(model: EventModel) {
        self.model = model
        self.titleLabel.text = model.title
        self.timeLabel.text = model.time
    }
}
