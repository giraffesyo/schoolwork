//
//  ContentView.swift
//  Exam3_McQuade_Michael Watch App
//
//  Created by Michael McQuade on 11/16/23.
//

import SwiftUI

struct ContentView: View {
  @StateObject var words = Words()

  var body: some View {
    VStack {

      Text("Top 3 words recognized")
        .multilineTextAlignment(.center)
        .font(.title2)
      List(words.value, id: \.self) { word in
        Text(word)
          .font(.title2)
          .fontWeight(.bold)
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
