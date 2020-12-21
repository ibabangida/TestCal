//
//  MonthDataManager.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/08.
//

import Foundation
import SwiftUI

class MonthDataManger  {
    private var year: Int
    private var month: Int
    private var dates: [Date] = []
    
    // initialize based on today
    init() {
        let today = Date()
        let calendar = Calendar(identifier: .gregorian)
        year = calendar.component(.year, from: today)
        month = calendar.component(.month, from: today)
        reload(year: self.year, month: self.month)
   }
    
    // initialize with year and month
    init(year: Int, month: Int) {
        self.year  = year
        self.month = month
        reload(year: year, month: month)
    }

    // reload
    func reload(year: Int, month: Int) {
        self.year  = year
        self.month = month
        
        // delete previous data
        dates.removeAll()
        
        // set calendar(7*6)
        let calendar = Calendar(identifier: .gregorian)
        let first_date = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let index = calendar.component(.weekday, from: first_date) - 1
        for i in 0..<42 {
            let date = Calendar(identifier: .gregorian).date(byAdding: .day, value: i - index, to: first_date)!
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
    
    // get view
    func getView() -> some View {
        return CalendarView(dates: dates, year: year, month: month)
    }
    
    func getYear() -> Int {
        return self.year
    }
    
    func getMonth() -> Int {
        return self.month
    }
}
