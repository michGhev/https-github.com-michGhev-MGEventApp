//
//  AddEventVC + Extensions.swift
//  MGEventApp
//
//  Created by Michael Ghevondyan on 14.08.23.
//

import UIKit

extension EventsVC: UICalendarViewDelegate {
    
    func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let day = dateComponents.day else {
            return nil
        }
        guard let month = dateComponents.month else {
            return nil
        }
        guard let year = dateComponents.year else {
            return nil
        }
        
        if (self.vm.getDatesList().value.contains(where: { $0.day == day })) && (self.vm.getDatesList().value.contains(where: { $0.month == month }))  && (self.vm.getDatesList().value.contains(where: { $0.year == year })){
            return UICalendarView.Decoration.default(color: Colors.lightBlueColor, size: .small)
        }
        
        return nil
    }
}

extension EventsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
