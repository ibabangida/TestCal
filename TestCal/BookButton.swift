//
//  BookButton.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/19.
//

import Foundation
import SwiftUI

struct BookButton: View {
    private let date: Date
    private let category: String
    private let save_index: Int
    private let index: Int
    private let shift: Shift
    private let hour_strs: [String]
    private static let min_strs = ["00", "15", "30", "45"]
    
    @State private var hour_index: Int = 1
    @State private var min_index: Int = 1
    @State private var is_mine: Bool = true
    @State private var core_data_manager = CoreDataManager.shared
    @EnvironmentObject private var popover_condition: PopoverCondition
    
    init(date: Date, category: String, save_index: Int, index: Int, shift: Shift) {
        self.date = date
        self.category = category
        self.save_index = save_index
        self.index = index
        self.shift = shift
        self.hour_strs = [(shift.hour - 1).description, shift.hour.description, (shift.hour + 1).description]
    }
    
    private func hasSave() -> Bool {
        let reservation = core_data_manager.getReservation(date: date, category: category, index: save_index)
        return reservation != nil
    }
    
    private func getTimeText() -> String {
        let reservation = core_data_manager.getReservation(date: date, category: category, index: save_index)
        if reservation == nil {
            return shift.getTimeText()
        }
        
        let hour = Int(reservation!.hour)
        let min = Int(reservation!.min)
        return (hour < 10 ? "0" : "") + hour.description + ":" + (min < 10 ? "0" : "") + min.description
    }
    
    private func initPopover() {
        let reservation = core_data_manager.getReservation(date: date, category: category, index: save_index)
        
        let hour = reservation == nil ? shift.hour : Int(reservation!.hour)
        let min = reservation == nil ? shift.min : Int(reservation!.min)
        
        if let index = hour_strs.firstIndex(of: hour.description) {
            hour_index = index
        } else {
            hour_index = 1
        }
        
        if let index = BookButton.min_strs.firstIndex(of: (min < 10 ? "0" : "") + min.description) {
            min_index = index
        } else {
            min_index = 0
        }
        
        is_mine = reservation == nil ? true : reservation!.is_mine
    }
    
    private func deleteReservation() {
        let reservation = core_data_manager.getReservation(date: date, category: category, index: save_index)
        if reservation != nil {
            core_data_manager.delete(src: reservation!)
        }
    }
    
    private func addReservation() {
        let hour = Int(hour_strs[hour_index])!
        let min = min_index == 0 ? 0 : Int(BookButton.min_strs[min_index])!
        _ = core_data_manager.addReservation(date: date, category: category, index: save_index, hour: hour, min: min, is_mine: is_mine)
    }
    
    var body : some View {
        Button(action: {
            if popover_condition.enablePush(index: index) {
                initPopover()
                popover_condition.conditions[index].toggle()
            }
        }, label: {
            if hasSave() {
                Text(getTimeText()).strikethrough()
            } else {
                Text(getTimeText())
            }
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
                        ForEach(0 ..< BookButton.min_strs.count) { i in
                            Text(BookButton.min_strs[i])
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
                    Spacer()
                    
                    Button(action: {
                        deleteReservation()
                        core_data_manager.save()
                    }, label: {
                        Text("Delete").font(.title3)
                    })
                    .disabled(!hasSave())
                    
                    Spacer()
                    Divider()
                    Spacer()
                    
                    Button(action: {
                        deleteReservation()
                        addReservation()
                        core_data_manager.save()
                        popover_condition.conditions[index].toggle()
                    }, label: {
                        Text("Save").font(.title3)
                    })
                    
                    Spacer()
                }
                .padding(.all, 10)
                .background(Color(UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1.0)))
            }
        )
        .padding(.vertical, 0.5)
    }
}
