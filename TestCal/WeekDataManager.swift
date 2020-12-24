//
//  WeekDataManager.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/14.
//

import Foundation
import SwiftUI

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
    
    // get view
    func getView() -> some View {
        let calendar = Calendar(identifier: .gregorian)
        
        return LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
            ForEach(0..<7) { i in
                let d = calendar.component(.day, from: self.dates[i])
                let m = calendar.component(.month, from: self.dates[i])
                
                let today = Date()
                let today_d = calendar.component(.day, from: today)
                let today_m = calendar.component(.month, from: today)
                
                let is_today = today_d == d && today_m == m
                
                if (is_today) {
                    RoundedRectangle(cornerRadius: 3.0).fill(Color.black)
                        .frame(height: 50)
                        .overlay(Circle().fill(Color.red))
                        .overlay(VStack{
                            Text(calendar.shortWeekdaySymbols[i])
                            Text(calendar.component(.day, from: self.dates[i]).description)
                        })
                        .foregroundColor(.white)
                } else {
                    RoundedRectangle(cornerRadius: 3.0).fill(Color.black)
                        .frame(height: 50)
                        .overlay(VStack{
                            Text(calendar.shortWeekdaySymbols[i])
                            Text(calendar.component(.day, from: self.dates[i]).description)
                        })
                        .foregroundColor(.white)
                }
            }
        }
        .padding(3.0)
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
