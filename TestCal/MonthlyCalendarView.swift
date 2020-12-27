//
//  MonthlyCalendarView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/17.
//

import Foundation
import SwiftUI

struct MonthlyCalendarView : View {
    private let dates : [Date]
    private let month: Int
    @EnvironmentObject var popover_condition: PopoverCondition
    
    init(dates: [Date], month: Int) {
        self.dates = dates
        self.month = month
    }
    
    var body : some View {
        VStack {
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                let symbols = Calendar(identifier: .gregorian).shortWeekdaySymbols
                ForEach(0..<symbols.count) { i in
                    RoundedRectangle(cornerRadius: 3.0).fill(Color.black)
                        .frame(height: 25)
                        .overlay(Text(symbols[i]))
                        .foregroundColor(.white)
                }
                
            }
            .padding(3.0)
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                let calendar = Calendar(identifier: .gregorian)
                                
                ForEach(0..<dates.count) { i in
                    let day = calendar.component(.day, from: dates[i])
                    let is_target_month = month == calendar.component(.month, from: dates[i])
                    let is_today = calendar.isDateInToday(dates[i])
                    
                    VStack {
                        if (is_today) {
                            RoundedRectangle(cornerRadius: 3.0).fill(is_target_month ? Color.black : Color.gray)
                                .frame(height: 25)
                                .overlay(Circle().fill(Color.red))
                                .overlay(Text(day.description))
                                .foregroundColor(.white)
                                .padding(.bottom, 2.0)
                        } else {
                            RoundedRectangle(cornerRadius: 3.0).fill(is_target_month ? Color.black : Color.gray)
                                .frame(height: 25)
                                .overlay(Text(day.description))
                                .foregroundColor(.white)
                                .padding(.bottom, 2.0)
                        }
                        
                        HStack {
                            ForEach(CommonDefine.shift_type.indices) { j in
                                let shifts = DefaultWorkScheduleLoader.shared.getDefaultShifts(type: CommonDefine.shift_type[j])
                                
                                VStack {
                                    ForEach(shifts.indices) { k in
                                        let index = i * CommonDefine.shift_type.indices.count * shifts.indices.count + j * shifts.indices.count + k
                                        
                                        BookButtonView(date: dates[i], category: CommonDefine.shift_type[j], save_index: k, index: index, shift: shifts[k])
                                    }
                                }
                            }
                        }
                    }
                    .background(Color(UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)))
                }
            }
            .padding(3.0)
        }
        .padding(5.0)
        .environmentObject(PopoverCondition())
    }
}

