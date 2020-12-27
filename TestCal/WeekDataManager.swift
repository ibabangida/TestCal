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
    
    init() {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        
        self.year = year
        self.month = month
        
        start_date = calendar.date(from: DateComponents(year: year, month: month, day: 1, hour: 0, minute: 0))!
        start_date = getLastSunday(date: start_date)

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
        let calendar = Calendar(identifier: .gregorian)
        
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        let day = calendar.component(.day, from: today)
        
        start_date = getLastSunday(date: calendar.date(from: DateComponents(year: year, month: month, day: day, hour: 0, minute: 0))!)
        
        reload()
    }
    
    // reload given month
    func reloadGivenMonth(year: Int, month: Int) {
        let calendar = Calendar(identifier: .gregorian)
        start_date = calendar.date(from: DateComponents(year: year, month: month, day: 1, hour: 0, minute: 0))!
        
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
    
    private func getLastSunday(date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let offset = 1 - calendar.component(.weekday, from: date)
        return calendar.date(byAdding: .day, value: offset, to: date)!
    }
}
