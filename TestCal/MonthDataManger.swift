//
//  MonthDataManager.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/08.
//

import Foundation

class MonthDataManger  {
    private var year: Int
    private var month: Int
    private var dates: [Date] = []
    private var start_date: Date
    
    // initialize based on today
    init() {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        year = calendar.component(.year, from: today)
        month = calendar.component(.month, from: today)
        start_date = calendar.date(from: DateComponents(year: year, month: month, day: 1, hour: 0, minute: 0))!
        
        reload(year: self.year, month: self.month)
   }
    
    // initialize with year and month
    init(year: Int, month: Int) {
        let calendar = Calendar(identifier: .gregorian)
        self.year  = year
        self.month = month
        start_date = calendar.date(from: DateComponents(year: year, month: month, day: 1, hour: 0, minute: 0))!
        
        reload(year: year, month: month)
    }

    // reload
    func reload(year: Int, month: Int) {
        let calendar = Calendar(identifier: .gregorian)
        self.year  = year
        self.month = month
        start_date = calendar.date(from: DateComponents(year: year, month: month, day: 1, hour: 0, minute: 0))!
        
        // delete previous data
        dates.removeAll()
        
        // set calendar(7*6)
        let index = calendar.component(.weekday, from: start_date) - 1
        for i in 0..<42 {
            let date = Calendar(identifier: .gregorian).date(byAdding: .day, value: i - index, to: start_date)!
            dates.append(date)
        }
    }
    
    // reload current month
    func reloadCurrMonth() {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        year = calendar.component(.year, from: today)
        month = calendar.component(.month, from: today)
        reload(year: year, month: month)
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
