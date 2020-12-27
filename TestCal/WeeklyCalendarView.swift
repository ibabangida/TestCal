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
    private var min_hour: Int?
    private var max_hour: Int?
    
    init (dates: [Date]) {
        self.dates = dates
        
        for type in CommonDefine.shift_type {
            let shifts = DefaultWorkScheduleLoader.shared.getDefaultShifts(type: type)
            if min_hour == nil {
                min_hour = shifts.sorted{$0.hour < $1.hour}[0].hour
            } else {
                min_hour = min(min_hour!, shifts.sorted{$0.hour < $1.hour}[0].hour)
            }
            
            if max_hour == nil {
                max_hour = shifts.sorted{$0.hour > $1.hour}[0].hour
            } else {
                max_hour = min(max_hour!, shifts.sorted{$0.hour > $1.hour}[0].hour)
            }
        }
        min_hour! -= 2
        max_hour! += 2
    }
    
    var body : some View {
        let calendar = Calendar(identifier: .gregorian)
        
        VStack {
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
            
            LazyVGrid(columns: Array(repeating: .init(.flexible(), alignment: .top), count: 8)) {
                let height_per_hour: CGFloat = 60
                VStack(spacing: 0) {
                    ForEach(min_hour! + 1 ..< max_hour! + 2) { i in
                        Text(i.description).frame(height: height_per_hour)
                    }
                }
                
                ForEach(0..<dates.count) { i in
                    HStack(spacing: 1) {                        ForEach(CommonDefine.shift_type.indices) { j in
                            let shifts = DefaultWorkScheduleLoader.shared.getDefaultShifts(type: CommonDefine.shift_type[j])
                            
                            ZStack {
                                ForEach(shifts.indices) { k in
                                    let index = i * CommonDefine.shift_type.indices.count * shifts.indices.count + j * shifts.indices.count + k
                                    
                                    BookButtonView(date: dates[i], category: CommonDefine.shift_type[j], save_index: k, index: index, shift: shifts[k], is_show_week: true, height: height_per_hour)
                                }
                            }
                        }
                    }
                }
            }
            .padding(3.0)
        }
        .padding(5.0)
        .environmentObject(PopoverCondition())
    }
}
