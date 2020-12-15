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
    private var target_date: Date
    private var dates: [Date] = []
 
    init() {
        let today = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        
        self.year = year
        self.month = month
        self.target_date = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        
        reload()
    }
    
    // reload
    func reload() {
        // delete previous data
        dates.removeAll()
        
        // init value
        let calendar = Calendar.current
        self.year = calendar.component(.year, from: target_date)
        self.month = calendar.component(.month, from: target_date)
        
        // set calendar
        let index = calendar.component(.weekday, from: target_date) - 1
        for i in 0..<7 {
            let date = Calendar.current.date(byAdding: .day, value: i - index, to: target_date)!
            dates.append(date)
        }
    }
    
    // reload next week
    func reloadNextWeek() {
        target_date = Calendar.current.date(byAdding: .day, value: 7, to: target_date)!
        reload()
    }
    
    // reload next week
    func reloadPrevWeek() {
        target_date = Calendar.current.date(byAdding: .day, value: -7, to: target_date)!
        reload()
    }
    
    // reload current month
    func reloadCurrWeek() {
        target_date = Date()
        reload()
    }
    
    // reload given month
    func reloadGivenMonth(year: Int, month: Int) {
        let calendar = Calendar.current
        self.year = year
        self.month = month
        self.target_date = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        
        reload()
    }
    
    // get view
    func getView() -> some View {
        let calendar = Calendar.current
        
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
        return self.year
    }
    
    func getMonth() -> Int {
        return self.month
    }
}
