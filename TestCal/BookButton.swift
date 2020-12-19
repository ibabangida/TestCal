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
    @State private var has_save: Bool = false
    @State private var reservation: Optional<Reservation> = nil
    @EnvironmentObject private var popover_condition: PopoverCondition
    
    init(date: Date, category: String, save_index: Int, index: Int, shift: Shift) {
        self.date = date
        self.category = category
        self.save_index = save_index
        self.index = index
        self.shift = shift
        self.hour_strs = [(shift.hour - 1).description, shift.hour.description, (shift.hour + 1).description]
        
        self._reservation = State(initialValue: CoreDataManager.shared.getReservation(date: date, category: category, index: save_index))
        
        if reservation != nil {
            self._has_save = State(initialValue: true)
        }
    }
    
    private func getTimeText() -> String {
        if reservation == nil {
            return shift.getTimeText()
        }
        
        let hour = Int(reservation!.hour)
        let min = Int(reservation!.min)
        return (hour < 10 ? "0" : "") + hour.description + ":" + (min < 10 ? "0" : "") + min.description
    }
    
    private func setTimeIndex() {
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
    }
    
    private func deleteReservation() {
        if reservation != nil {
            CoreDataManager.shared.delete(src: reservation!)
        }
    }
    
    private func addReservation() {
        let hour = Int(hour_strs[hour_index])!
        let min = min_index == 0 ? 0 : Int(BookButton.min_strs[min_index])!
        reservation = CoreDataManager.shared.addReservation(date: date, category: category, index: save_index, hour: hour, min: min, is_mine: is_mine)
    }
    
    var body : some View {
        Button(action: {
            if popover_condition.enablePush(index: index) {
                setTimeIndex()
                popover_condition.conditions[index].toggle()
            }
        }, label: {
            if has_save {
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
                        CoreDataManager.shared.save()
                        has_save = false
                    }, label: {
                        Text("Delete").font(.title3)
                    })
                    .disabled(!has_save)
                    
                    Spacer()
                    Divider()
                    Spacer()
                    
                    Button(action: {
                        deleteReservation()
                        addReservation()
                        CoreDataManager.shared.save()
                        has_save = true
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
