//
//  DefaultWorkScheduleLoader.swift
//  TestCal
//
//  Created by Keisuke Iba on 2020/11/08.
//

import Foundation

struct Shift : Identifiable {
    var id = UUID()
    var hour: Int
    var min: Int
    var text = String()
    
    // initialize with hour, min
    init(hour: Int, min: Int) {
        self.hour = hour
        self.min = min
        
        // initialize text as HH:MM
        // if HH < 10 or MM < 10, pad zero
        self.text = String(format: "%@%@:%@%@",
                           hour < 10 ? "0" : "",
                           hour.description,
                           min < 10 ? "0" : "",
                           min.description)
    }
    
    // initialize with HH:MM
    init(text: String) {
        self.text = text
        
        // set hour, minutes
        let parts = text.split(separator: ":")
        let hh = parts[0]
        let mm = parts[1]
        self.hour = Int(hh.prefix(1) == "0" ? hh.dropFirst(1) : hh)!
        self.min = Int(mm.prefix(1) == "0" ? mm.dropFirst(1) : mm)!
    }
    
    // get time text as HH:MM
    func getTimeText() -> String {
        return text
    }
}

// singleton which load work schedule from App.plist
// format must be HH:MM
// ex) 08:00, 13:00, 21:30
// @note: it is a kind of technique to detach programming code from resource.
//        in this case, resource is the set of possible appointment schedule.
class DefaultWorkScheduleLoader {
    var shifts : Array<Shift> = []
    static let shared = DefaultWorkScheduleLoader()
    
    private init() {
        // get the path of App.plist
        let path = Bundle.main.path(forResource: "App", ofType: "plist")
        
        // read App.plist to get preset of time
        let config = NSDictionary(contentsOfFile: path!)
        
        if (config != nil) {
            if let prop: [String : Any] = config as? [String : Any] {
                if let timesets : [String : String] = prop["AppointedTimeSet"] as? [String : String] {
                    for time in timesets.values.sorted() {
                        self.shifts.append(Shift(text: time))
                    }
                }
            }
        }
    }
    
    func getShifts() -> Array<Shift> {
        return shifts;
    }
}
