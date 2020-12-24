//
//  ContentView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/08.
//

import Foundation
import SwiftUI

struct ContentView: View {
    @State private var selected_mode = 0
    @State private var year: Int = Calendar(identifier: .gregorian).component(.year, from: Date())
    @State private var month: Int = Calendar(identifier: .gregorian).component(.month, from: Date())
    
    @ObservedObject private var show_reservation_week = ShowReservation()
    @ObservedObject private var show_reservation_month = ShowReservation()
    
    private var month_data_manager = MonthDataManger()
    private var week_data_manager = WeekDataManger()
    
    init() {
        updateShowReservation()
    }
    
    private func updateShowReservation() {
        let calendar = Calendar(identifier: .gregorian)
        let start_date_week = week_data_manager.getStartDate()
        let start_date_month = month_data_manager.getStartDate()
        let end_date_week = calendar.date(byAdding: .day, value: 7, to: start_date_week)!
        let end_date_month = calendar.date(byAdding: .month, value: 1, to: start_date_month)!
        
        show_reservation_week.updateDuration(start_date: start_date_week, end_date: end_date_week)
        show_reservation_month.updateDuration(start_date: start_date_month, end_date: end_date_month)
    }
    
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
        updateShowReservation()
    }
    
    private func toPrev() {
        selected_mode == 0 ? toPrevMonth() : toPrevWeek()
        updateShowReservation()
    }
    
    private func toCurr() {
        selected_mode == 0 ? toCurrMonth() : toCurrWeek()
        updateShowReservation()
    }
    
    private func getStartDate() -> Date {
        return selected_mode == 0 ? month_data_manager.getStartDate() : week_data_manager.getStartDate()
    }
    
    private func getEndDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        let start_date = getStartDate()
        
        return selected_mode == 0 ? calendar.date(byAdding: .month, value: 1, to: start_date)! : calendar.date(byAdding: .day, value: 7, to: start_date)!
    }
    
    // body
    var body: some View {
        VStack {
            // Header
            VStack {
                Picker("", selection: $selected_mode) {
                    Text("Month")
                        .tag(0)
                    Text("Week")
                        .tag(1)
                }
                .padding(.vertical, 3.0)
                .pickerStyle(SegmentedPickerStyle())
                
                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 4)) {
                    Text(self.year.description + " / " + self.month.description).font(.largeTitle)
                    
                    Text("")
                    if (selected_mode == 0) {
                        show_reservation_month.getView()
                    } else {
                        show_reservation_week.getView()
                    }
                    
                    HStack {
                        Spacer()
                        Button(action: {toPrev()}, label: {Text("<")})
                        Spacer()
                        Button(action: {toCurr()}, label: {Text("today")})
                        Spacer()
                        Button(action: {toNext()}, label: {Text(">")})
                        Spacer()
                    }
                }
            }
            
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
