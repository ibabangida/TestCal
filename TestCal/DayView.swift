//
//  DayView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/17.
//

import Foundation
import SwiftUI

struct DayView : View {
    private let dates : [Date]
    private let year: Int
    private let month: Int
    private static let shift_type = ["A", "B"]
    private var save: Reservation?
    @EnvironmentObject var popover_condition: PopoverCondition
    
    @State var show_popover = [Bool](repeating: false, count: 42)
    
    init(dates: [Date], year: Int, month: Int) {
        self.dates = dates
        self.year = year
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
                        
                        HStack {
                            ForEach(DayView.shift_type.indices) { j in
                                let shifts = DefaultWorkScheduleLoader.shared.getDefaultShifts(type: DayView.shift_type[j])
                                
                                VStack {
                                    ForEach(shifts.indices) { k in
                                        let index = i * DayView.shift_type.indices.count * shifts.indices.count + j * shifts.indices.count + k
                                        
                                        BookButton(date: self.dates[i], category: DayView.shift_type[j], save_index: k, index: index, shift: shifts[k])
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
        .environmentObject(PopoverCondition())
    }
}

