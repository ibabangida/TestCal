//
//  ApptData.swift
//  MenardCal
//
//  Created by Keisuke Iba on 2020/11/03.
//

import Foundation
import UIKit

class ApptData: Identifiable {
    var id = UUID()
    var begin: Date
    var end: Date
    var staff: String
    
    // initialize
    init(begin: Date, end: Date, staff: String) {
        self.begin = begin
        self.end   = end
        self.staff = staff
    }
}
