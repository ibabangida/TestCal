//
//  WeekDataManager.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/14.
//

import Foundation

class WeekDataManger {
    private var year: Int
    private var month: Int
    private var start_date: Date
    private var dates: [Date] = []
    private var min_hour: Int?
    private var max_hour: Int?
    private static let shift_type = ["A", "B"]
    
    init() {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        
        self.year = year
        self.month = month
        start_date = calendar.date(from: DateComponents(year: year, month: month, day: 1, hour: 0, minute: 0))!
        
        for type in WeekDataManger.shift_type {
            let shifts = DefaultWorkScheduleLoader.shared.getDefaultShifts(type: type)
            for shift in shifts {
                if min_hour == nil {
                    min_hour = shift.hour
                } else if shift.hour < min_hour! {
                    min_hour = shift.hour
                }
                
                if max_hour == nil {
                    max_hour = shift.hour
                } else if shift.hour > max_hour! {
                    max_hour = shift.hour
                }
            }
        }
        min_hour! -= 2
        max_hour! += 2
        
        reload()
    }
    
    // reload
    func reload() {
        // delete previous data
        dates.removeAll()
        
        // init value
        let calendar = Calendar(identifier: .gregorian)
        self.year = calendar.component(.year, from: start_date)
        self.month = calendar.component(.month, from: start_date)
        
        // set calendar
        let index = calendar.component(.weekday, from: start_date) - 1
        for i in 0..<7 {
            let date = Calendar(identifier: .gregorian).date(byAdding: .day, value: i - index, to: start_date)!
            dates.append(date)
        }
    }
    
    // reload next week
    func reloadNextWeek() {
        start_date = Calendar(identifier: .gregorian).date(byAdding: .day, value: 7, to: start_date)!
        reload()
    }
    
    // reload next week
    func reloadPrevWeek() {
        start_date = Calendar(identifier: .gregorian).date(byAdding: .day, value: -7, to: start_date)!
        reload()
    }
    
    // reload current month
    func reloadCurrWeek() {
        start_date = Date()
        reload()
    }
    
    // reload given month
    func reloadGivenMonth(year: Int, month: Int) {
        let calendar = Calendar(identifier: .gregorian)
        self.year = year
        self.month = month
        self.start_date = calendar.date(from: DateComponents(year: year, month: month, day: 1, hour: 0, minute: 0))!
        
        reload()
    }
    
    func getDates() -> [Date] {
        return dates
    }
    
    func getYear() -> Int {
        return year
    }
    
    func getMonth() -> Int {
        return month
    }
    
    func getStartDate() -> Date {
        return start_date
    }
}
