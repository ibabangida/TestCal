//
//  BookButtonView.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/19.
//

import Foundation
import SwiftUI

struct BookButtonView: View {
    private let index: Int
    private let shift: Shift
    private let is_show_week: Bool
    private let height: CGFloat
    
    private let data_ctrl: BookDataController
    private let hour_strs: [String]
    private static let min_strs = ["00", "15", "30", "45"]
    
    @State private var hour_index: Int = 1
    @State private var min_index: Int = 1
    @State private var is_mine: Bool = true
    @EnvironmentObject private var popover_condition: PopoverCondition
    
    init(date: Date, category: String, save_index: Int, index: Int, shift: Shift, is_show_week: Bool = false, height: CGFloat = 0.0) {
        self.index = index
        self.shift = shift
        self.is_show_week = is_show_week
        self.height = height
        
        data_ctrl = BookDataController(date: date, category: category, save_index:  save_index, shift: shift)
        hour_strs = [(shift.hour - 1).description, shift.hour.description, (shift.hour + 1).description]
    }
    
    private func getOffset() -> CGFloat {
        if !is_show_week {
            return 0
        }
        
        var min_hour = 24
        for type in CommonDefine.shift_type {
            let shifts = DefaultWorkScheduleLoader.shared.getDefaultShifts(type: type)
            min_hour = min(min_hour, shifts.sorted{$0.hour < $1.hour}[0].hour)
        }
        min_hour -= 2
        
        let hour: Int
        let min: Int
        let reservation = data_ctrl.getReservation()
        if reservation == nil {
            hour = shift.hour
            min = shift.min
        } else {
            hour = Int(reservation!.hour)
            min = Int(reservation!.min)
        }
        
        return (CGFloat(hour - min_hour) + CGFloat(min) / 60.0) * height
    }
    
    private func getPaddingVertical() -> CGFloat {
        return is_show_week ? 0 : 5.5
    }
    
    private func drawShapeForWeek() -> some View {
        if data_ctrl.hasSave() {
            return Rectangle().fill(Color.blue).frame(height: height)
        } else {
            return Rectangle().fill(Color.gray.opacity(0.5)).frame(height: height)
        }
    }
    
    private func drawShapeForMonth() -> some View {
        let text: String;
        let reservation = data_ctrl.getReservation()
        if reservation == nil {
            text = shift.getTimeText()
        } else {
            let hour = Int(reservation!.hour)
            let min = Int(reservation!.min)
            text = (hour < 10 ? "0" : "") + hour.description + ":" + (min < 10 ? "0" : "") + min.description
        }
        
        if data_ctrl.hasSave() {
            return Text(text).strikethrough()
        } else {
            return Text(text)
        }
    }
    
    private func initPopover() {
        let reservation = data_ctrl.getReservation()
        let hour = reservation == nil ? shift.hour : Int(reservation!.hour)
        let min = reservation == nil ? shift.min : Int(reservation!.min)
        
        if let index = hour_strs.firstIndex(of: hour.description) {
            hour_index = index
        } else {
            hour_index = 1
        }
        
        if let index = BookButtonView.min_strs.firstIndex(of: (min < 10 ? "0" : "") + min.description) {
            min_index = index
        } else {
            min_index = 0
        }
        
        is_mine = reservation == nil ? true : reservation!.is_mine
    }
    
    var body : some View {
        GeometryReader { geometry in
            Button(action: {
                if popover_condition.enablePush(index: index) {
                    initPopover()
                    popover_condition.conditions[index].toggle()
                }
            }, label: {
                if is_show_week {
                    drawShapeForWeek()
                } else {
                    drawShapeForMonth()
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
                            ForEach(0 ..< BookButtonView.min_strs.count) { i in
                                Text(BookButtonView.min_strs[i])
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
                            data_ctrl.deleteReservation()
                            data_ctrl.save()
                            popover_condition.conditions[index].toggle()
                        }, label: {
                            Text("Delete").font(.title3)
                        })
                        .disabled(!data_ctrl.hasSave())
                        
                        Spacer()
                        Divider()
                        Spacer()
                        
                        Button(action: {
                            data_ctrl.deleteReservation()
                            
                            let hour = Int(hour_strs[hour_index])!
                            let min = min_index == 0 ? 0 : Int(BookButtonView.min_strs[min_index])!
                            data_ctrl.addReservation(hour: hour, min: min, is_mine: is_mine)
                            data_ctrl.save()
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
            .position(x: geometry.size.width / 2, y: getOffset())
        }
        .padding(.vertical, getPaddingVertical())
    }
}
