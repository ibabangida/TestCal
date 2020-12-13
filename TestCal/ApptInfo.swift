//
//  ApptInfo.swift
//  MenardCal
//
//  Created by AhartIII on 2020/10/21.
//

import Foundation

// @note a class is used as a reference, though a struct is used as a value
class ApptInfo: Identifiable {
  var id = UUID()
  var hrs: Int
  var min: Int
  var text = String()
  var is_available = true
 
  // initialize with hour, min
  init(hrs: Int, min: Int) {
    self.hrs = hrs
    self.min = min
    
    // initialize text as HH:MM
    // if HH < 10 or MM < 10, pad zero
    self.text = String(format: "%@%@:%@%@",
                  hrs < 10 ? "0" : "",
                  hrs.description,
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
    self.hrs = Int(hh.prefix(1) == "0" ? hh.dropFirst(1) : hh)!
    self.min = Int(mm.prefix(1) == "0" ? mm.dropFirst(1) : mm)!
  }
 
  // get time text as HH:MM
  // @note: it's smart to use this function to reduce writing like 'hrs + ":" + min'
  func getTimeText() -> String {
    return text
  }
    
  // toggle is available
  // @note technically, you can change this val directly from outside,
  //       but you can add any modification easily through this function
  func toggleIsAvailable() {
    is_available.toggle()
  }
}

// load preset time from App.plist
// format must be HH:MM
// ex) 08:00, 13:00, 21:30
// @note: it is a kind of technique to detach programming code from resource.
//        in this case, resource is the set of possible appointment schedule.
class ApptTimeSetLoader {
  static func getApptTimeSet() -> Array<ApptInfo> {
    var dst : Array<ApptInfo> = []
    
    // get the path of App.plist
    let path = Bundle.main.path(forResource: "App", ofType: "plist")
    
    // read App.plist to get preset of time
    let config = NSDictionary(contentsOfFile: path!)
  
    if (config != nil) {
      if let prop: [String : Any] = config as? [String : Any] {
        if let timesets : [String : String] = prop["AppointedTimeSet"] as? [String : String] {
          for time in timesets.values.sorted() {
            dst.append(ApptInfo(text: time))
          }
        }
      }
    }
    
    return dst;
  }
}
