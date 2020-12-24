//
//  ContentView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/08.
//

import SwiftUI

struct ContentView: View {
    @State private var core_data_manager = CoreDataManager.shared
    @State private var selected_mode = 0
    @State private var year: Int = Calendar(identifier: .gregorian).component(.year, from: Date())
    @State private var month: Int = Calendar(identifier: .gregorian).component(.month, from: Date())
    
    private var month_data_manager = MonthDataManger()
    private var week_data_manager = WeekDataManger()
    
    init() {
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
    }
    
    private func toPrev() {
        selected_mode == 0 ? toPrevMonth() : toPrevWeek()
    }
    
    private func toCurr() {
        selected_mode == 0 ? toCurrMonth() : toCurrWeek()
    }
    
    private func getBookingNum() -> Int {
        let predicate = core_data_manager.generatePredicate(start_date: getStartDate(), end_date: getEndDate())
        
        return core_data_manager.getReservations(predicate: predicate).count
    }
    
    private func getVacancyNum() -> Int {
        let start_date = getStartDate()
        let end_date = getEndDate()
        let day_num = Int(DateInterval(start: start_date, end: end_date).duration / (60 * 60 * 24))
        
        return day_num * DefaultWorkScheduleLoader.shared.getShiftPatternNum() - getBookingNum()
    }
    
    private func getMineNum() -> Int {
        let predicate = core_data_manager.generatePredicate(start_date: getStartDate(), end_date: getEndDate(), is_mine: true)
        
        return core_data_manager.getReservations(predicate: predicate).count
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
                    
                    VStack {
                        HStack {
                            Text("Booked(Mine)").font(.subheadline)
                            Spacer()
                            Text(getBookingNum().description + "(" + getMineNum().description + ")")
                        }
                        HStack {
                            Text("Vacant").font(.subheadline)
                            Spacer()
                            Text(getVacancyNum().description)
                        }
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
