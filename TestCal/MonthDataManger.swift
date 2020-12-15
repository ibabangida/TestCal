//
//  MonthDataManager.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/08.
//

import Foundation
import SwiftUI

struct TimeButton: View {
    let shift : Shift
    @State var is_show : Bool = false
    
    init(shift : Shift) {
        self.shift = shift
    }
    
    var body : some View {
        Button(action: {
            self.is_show.toggle()
        }, label: {
            Text(self.shift.getTimeText())
        })
        .popover(
            isPresented: self.$is_show,
          content: {
            Text("popover")
        })
        .padding(.vertical, 0.5)
        
    }
}

struct DayView : View {
    let dates : [Date]
    let year: Int
    let month: Int
    @State var show_popover = [Bool](repeating: false, count: 42)
    
    init(dates: [Date], year: Int, month: Int) {
        self.dates = dates
        self.year = year
        self.month = month
    }
    
    var body : some View {
        VStack {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                let symbols = Calendar.current.shortWeekdaySymbols
                ForEach(0..<symbols.count) { i in
                    RoundedRectangle(cornerRadius: 3.0).fill(Color.black)
                        .frame(height: 25)
                        .overlay(Text(symbols[i]))
                        .foregroundColor(.white)
                }
                
            }
            .padding(3.0)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                let calendar = Calendar.current
                
                ForEach(0..<dates.count) { i in
                    let d = calendar.component(.day, from: self.dates[i])
                    let m = calendar.component(.month, from: self.dates[i])
                    
                    let today = Date()
                    let today_d = calendar.component(.day, from: today)
                    let today_m = calendar.component(.month, from: today)
                    
                    let is_target_month = self.month == m
                    let is_today = today_d == d && today_m == m
                    
                    VStack {
                        if (is_today) {
                            RoundedRectangle(cornerRadius: 3.0).fill(is_target_month ? Color.black : Color.gray)
                                .frame(height: 25)
                                .overlay(Circle().fill(Color.red))
                                .overlay(Text(d.description))
                                .foregroundColor(.white)
                        } else {
                            RoundedRectangle(cornerRadius: 3.0).fill(is_target_month ? Color.black : Color.gray)
                                .frame(height: 25)
                                .overlay(Text(d.description))
                                .foregroundColor(.white)
                        }
                        
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                            ForEach(DefaultWorkScheduleLoader.shared.getShifts()) { shift in
                                TimeButton(shift: shift)
                            }
                        }
                    }
                    .background(Color(UIColor.lightGray))
                }
            }
            .padding(3.0)
        }
    }
}

class MonthDataManger  {
    private var year: Int
    private var month: Int
    private var dates: [Date] = []
    
    // initialize based on today
    init() {
        let today = Date()
        let calendar = Calendar.current
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
        let calendar = Calendar.current
        let first_date = calendar.date(from: DateComponents(year: year, month: month, day: 1))!
        let index = calendar.component(.weekday, from: first_date) - 1
        for i in 0..<42 {
            let date = Calendar.current.date(byAdding: .day, value: i - index, to: first_date)!
            dates.append(date)
        }
    }
    
    // reload current month
    func reloadCurrMonth() {
        let today = Date()
        let calendar = Calendar.current
        year = calendar.component(.year, from: today)
        month = calendar.component(.month, from: today)
        reload(year: year, month: month)
    }
    
    // get view
    func getView() -> some View {
        return DayView(dates: dates, year: year, month: month)
    }
    
    func getYear() -> Int {
        return self.year
    }
    
    func getMonth() -> Int {
        return self.month
    }
}
