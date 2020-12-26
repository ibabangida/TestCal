//
//  BookDataController.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/26.
//

import Foundation

class BookDataController: ObservableObject {
    private let date: Date
    private let category: String
    private let save_index: Int
    private let shift: Shift
    private var core_data_manager = CoreDataManager.shared
    
    init(date: Date, category: String, save_index: Int, shift: Shift) {
        self.date = date
        self.category = category
        self.save_index = save_index
        self.shift = shift
    }
    
    func hasSave() -> Bool {
        let reservation = getReservation()
        return reservation != nil
    }
    
    func save() {
        core_data_manager.save()
    }
    
    func deleteReservation() {
        let reservation = getReservation()
        if getReservation() != nil {
            core_data_manager.delete(src: reservation!)
        }
    }
    
    func addReservation(hour: Int, min: Int, is_mine: Bool) {
        _ = core_data_manager.addReservation(date: date, category: category, index: save_index, hour: hour, min: min, is_mine: is_mine)
    }
    
    func getReservation() -> Reservation? {
        return core_data_manager.getReservation(date: date, category: category, index: save_index)
    }
}
