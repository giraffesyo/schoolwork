//
//  ContentView.swift
//  Exercise4_McQuade_Michael
//
//  Created by Michael McQuade on 9/17/23.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    VStack {
      Image("logo-text")
        .resizable()
        .scaledToFit()
        .imageScale(.large)
        .foregroundColor(.accentColor)

        .padding()
      HStack {
        PlayerView(playerName: "Player 1")
        PlayerView(playerName: "Player 2")
      }
    }
  }
}

// new view for each player
struct PlayerView: View {
  var playerName: String
  var playerImage: String = "dragon-placeholder"
  var body: some View {
    VStack {
      Text(playerName)
            .font(.custom("AcademyEngravedLetPlain", size: 34))
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
      Image(playerImage)
        .resizable()
        .scaledToFit()
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
