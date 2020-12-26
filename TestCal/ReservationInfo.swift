//
//  ReservationInfo.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/24.
//

import Foundation

class ReservationInfo : ObservableObject {
    @Published private var reservations = [Reservation]()
    private var start_date = Date()
    private var end_date = Date()
    private var core_data_manager = CoreDataManager.shared
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateReservations), name: .save, object: nil)
    }
    
    func updateDuration(start_date: Date, end_date: Date) {
        self.start_date = start_date
        self.end_date = end_date
        updateReservations()
    }
    
    func getBookingNum() -> Int {
        return reservations.count
    }
    
    func getMineNum() -> Int {
        return reservations.filter({$0.is_mine == true}).count
    }
    
    func getVacancyNum() -> Int {
        let day_num = Int(DateInterval(start: start_date, end: end_date).duration / (60 * 60 * 24))
        
        return day_num * DefaultWorkScheduleLoader.shared.getShiftPatternNum() - getBookingNum()
    }
    
    @objc private func updateReservations() {
        let predicate = core_data_manager.generatePredicate(start_date: start_date, end_date: end_date)
        reservations = core_data_manager.getReservations(predicate: predicate)
    }
}
