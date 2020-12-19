//
//  DayView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/17.
//

import Foundation
import SwiftUI

class PopoverCondition : ObservableObject {
    @Published var conditions: [Bool] =
        Array(repeating: false, count: DefaultWorkScheduleLoader.shared.getShiftPatternNum() * 7 * 6)
    
    func enablePush(index: Int) -> Bool {
        for (i, is_on) in self.conditions.enumerated() {
            if i == index {
                continue
            }
            
            if is_on {
                return false
            }
        }
        
        return true
    }
}

struct TimeButton: View {
    private let date: Date
    private let category: String
    private let index: Int
    private let shift: Shift
    private let hour_strs: [String]
    private static let min_strs = ["00", "15", "30", "45"]
    
    @State private var is_show : Bool = false
    @State private var hour_index: Int = 1
    @State private var min_index: Int = 0
    @State private var is_mine: Bool = true
    @EnvironmentObject private var popover_condition: PopoverCondition
    
    init(date: Date, category: String, index: Int, shift: Shift) {
        self.date = date
        self.category = category
        self.index = index
        self.shift = shift
        self.hour_strs = [(shift.hour - 1).description, shift.hour.description, (shift.hour + 1).description]
    }
    
    var body : some View {
        Button(action: {
            if popover_condition.enablePush(index: index) {
                popover_condition.conditions[index].toggle()
            }
        }, label: {
            Text(shift.getTimeText())
        })
        .popover(
            isPresented: $popover_condition.conditions[index],
            content: {
                HStack {
                    Text("Hours")
                    Spacer()
                    Picker(selection: $hour_index, label: Text("time")) {
                        ForEach(0..<hour_strs.count) { i in
                            Text(hour_strs[i])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
                .padding(.all, 10)
                
                HStack {
                    Text("Minutes")
                    Spacer()
                    Picker(selection: $min_index, label: Text("time")) {
                        ForEach(0 ..< TimeButton.min_strs.count) { i in
                            Text(TimeButton.min_strs[i])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 200)
                }
                .padding(.all, 10)
                
                HStack {
                    Toggle(isOn: $is_mine) {
                        Text("Mine")
                    }
                    Spacer()
                }
                .padding(.all, 10)
                
                HStack {
                    Toggle(isOn: $is_mine) {
                        Text("Mine")
                    }
                    Spacer()
                }
                .padding(.all, 10)
            }
        )
        .padding(.vertical, 0.5)
    }
}

struct DayView : View {
    private let dates : [Date]
    private let year: Int
    private let month: Int
    private static let shift_type = ["A", "B"]
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
                                        
                                        TimeButton(date: self.dates[j], category: DayView.shift_type[j], index: index, shift: shifts[k])
                                    }
                                }
                            }
                            
                        }
                    }
                    .background(Color(UIColor.lightGray))
                }
            }
            .padding(3.0)
        }
        .environmentObject(PopoverCondition())
    }
}

