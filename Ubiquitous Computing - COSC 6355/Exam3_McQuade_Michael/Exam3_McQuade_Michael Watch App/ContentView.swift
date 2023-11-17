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
    // concatenate words into a single string
    let word = words.value.joined(separator: ",")
    VStack {

      Text("Top 3 words recognized")
        .multilineTextAlignment(.center)
        .font(.title2)
      Text(word)
        .font(.title2)
        .fontWeight(.bold)
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
