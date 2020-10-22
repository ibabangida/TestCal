//
//  ContentView.swift
//  MenardCal
//
//  Created by AhartIII on 2020/10/21.
//

import SwiftUI

struct ContentView: View {
  var apptTimes: [ApptInfo] = []

  var columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)

  var body: some View {
    LazyVGrid(columns: columns) {
      ForEach(apptTimes) { appTime in
        Button(action: { print("\(appTime.hrs) pressed") }, label: {
          Text("\(appTime.hrs):\(appTime.min)")
            .padding()
        })
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(apptTimes: testData)
  }
}
