//
//  PopoverCondition.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/12/19.
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
