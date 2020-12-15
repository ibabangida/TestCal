//
//  ContentView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/08.
//

import SwiftUI

struct ContentView: View {
    private var month_data_manager = MonthDataManger()
    private var week_data_manager = WeekDataManger()
    
    @State private var selected_mode = 0
    
    @State private var year: Int = Calendar.current.component(.year, from: Date())
    @State private var month: Int =  Calendar.current.component(.month, from: Date())
    
    init() {}
    
    private func toNextMonth() {
        if (self.month == 12) {
            self.month = 1
            self.year += 1
        } else {
            self.month += 1
        }
        
        month_data_manager.reload(year: self.year, month: self.month)
        
        week_data_manager.reloadGivenMonth(year: self.year, month: self.month)
    }
    
    private func toPrevMonth() {
        if (self.month == 1) {
            self.month = 12
            self.year -= 1
        } else {
            self.month -= 1
        }
        
        month_data_manager.reload(year: self.year, month: self.month)
        
        week_data_manager.reloadGivenMonth(year: self.year, month: self.month)
    }
    
    private func toCurrMonth() {
        month_data_manager.reloadCurrMonth()
        self.year = month_data_manager.getYear()
        self.month = month_data_manager.getMonth()
        
        week_data_manager.reloadGivenMonth(year: self.year, month: self.month)
    }
    
    private func toNextWeek() {
        week_data_manager.reloadNextWeek()
        self.year = week_data_manager.getYear()
        self.month = week_data_manager.getMonth()
        
        month_data_manager.reload(year: self.year, month: self.month)
    }
    
    private func toPrevWeek() {
        week_data_manager.reloadPrevWeek()
        self.year = week_data_manager.getYear()
        self.month = week_data_manager.getMonth()
        
        month_data_manager.reload(year: self.year, month: self.month)
    }
    
    private func toCurrWeek() {
        week_data_manager.reloadCurrWeek()
        self.year = week_data_manager.getYear()
        self.month = week_data_manager.getMonth()
        
        month_data_manager.reload(year: self.year, month: self.month)
    }
    
    private func toNext() {
        selected_mode == 0 ? toNextMonth() : toNextWeek()
    }
    
    private func toPrev() {
        selected_mode == 0 ? toPrevMonth() : toPrevWeek()
    }
    
    private func toCurr() {
        selected_mode == 0 ? toCurrMonth() : toCurrWeek()
    }
    
    // get header view
    private func getHeaderView() -> some View {
        return VStack {
            Picker("", selection: $selected_mode) {
                       Text("Month")
                           .tag(0)
                       Text("Week")
                           .tag(1)
            }
            .padding(.vertical, 10.0)
                   .pickerStyle(SegmentedPickerStyle())
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 2)) {
                Text(self.year.description + " / " + self.month.description).font(.title)
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 3)) {
                    Button(action: {toPrev()}, label: {Text("<")})
                    Button(action: {toCurr()}, label: {Text("today")})
                    Button(action: {toNext()}, label: {Text(">")})
                }
            }
        }
    }
    
    // body
    var body: some View {
        VStack {
            getHeaderView();
            
            Divider()
                .padding(.bottom, 7.0)
                .hidden()
            
            if (selected_mode == 0) {
                month_data_manager.getView()
            } else {
                week_data_manager.getView()
            }
            
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
