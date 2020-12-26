//
//  WeeklyCalendarView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/26.
//

import Foundation
import SwiftUI

struct WeeklyCalendarView : View {
    private var dates: [Date] = []
    
    init (dates: [Date]) {
        self.dates = dates
    }
    
    var body : some View {
        let calendar = Calendar(identifier: .gregorian)
        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 8)) {
            Text("")
            ForEach(0..<7) { i in
                let day = calendar.component(.day, from: dates[i])
                let is_today = calendar.isDateInToday(dates[i])
                
                if (is_today) {
                    RoundedRectangle(cornerRadius: 3.0).fill(Color.black)
                        .frame(height: 50)
                        .overlay(Circle().fill(Color.red))
                        .overlay(VStack{
                            Text(calendar.shortWeekdaySymbols[i])
                            Text(day.description)
                        })
                        .foregroundColor(.white)
                } else {
                    RoundedRectangle(cornerRadius: 3.0).fill(Color.black)
                        .frame(height: 50)
                        .overlay(VStack{
                            Text(calendar.shortWeekdaySymbols[i])
                            Text(day.description)
                        })
                        .foregroundColor(.white)
                }
            }
        }
        .padding(3.0)
    }
}
