//
//  DayView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/17.
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
            Text(self.shift.getTimeText()).scaledToFit()
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
                            VStack {
                                let shifts = DefaultWorkScheduleLoader.shared.getDefaultShifts(type: "A")
                                ForEach(shifts.indices) { i in
                                    TimeButton(shift: shifts[i])
                                }
                            }
                            
                            VStack {
                                ForEach(DefaultWorkScheduleLoader.shared.getDefaultShifts(type: "B")) { shift in
                                    TimeButton(shift: shift)
                                }
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
