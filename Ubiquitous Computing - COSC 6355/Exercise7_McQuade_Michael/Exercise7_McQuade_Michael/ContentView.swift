//
//  ContentView.swift
//  Exercise7_McQuade_Michael
//
//  Created by Michael McQuade on 10/28/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var bpm = BPM()
  var body: some View {
    VStack {
      // Single button w/ heart emoji
      Button(
        action: {

        },
        label: {
          Text("❤️")
        }
      ).font(.system(size: 150))

      HStack {
        Text("\(bpm.value, specifier: "%.0f")").font(.system(size: 70))
        VStack {
          Text("BPM").foregroundColor(.red).font(.system(size: 28)).font(.headline).bold()

        }.frame(width: .infinity)
        Spacer()
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
