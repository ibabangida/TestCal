//
//  ApptInfo.swift
//  MenardCal
//
//  Created by AhartIII on 2020/10/21.
//

import Foundation

struct ApptInfo: Identifiable {
  var id = UUID()

//  var bed: String
//
//  var hrs: Int
//  var mins: Int
//
//  var isAvailable: Bool
//  var myAppt: Bool
  var hrs: Int
  var min: Int

}

var testData = [
  ApptInfo(hrs: 10, min: 00),
  ApptInfo(hrs: 11, min: 00),
  ApptInfo(hrs: 13, min: 00),
  ApptInfo(hrs: 14, min: 00),
  ApptInfo(hrs: 16, min: 00),
  ApptInfo(hrs: 17, min: 00),
  ApptInfo(hrs: 19, min: 00),
  ApptInfo(hrs: 19, min: 30)
]
