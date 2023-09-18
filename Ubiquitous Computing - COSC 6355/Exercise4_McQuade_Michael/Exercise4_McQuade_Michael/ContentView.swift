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
     
      TabView {
        GameView()
          .tabItem({
              Image("fire_off")
              Text("Game")
          })

      }
    }
  }
}

struct GameView: View {
  var gameStatus: String = "Prepare for the battle!"
  var body: some View {
      VStack{
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
          Text(gameStatus)
              .font(.custom("AcademyEngravedLetPlain", size: 34))
              .fontWeight(.bold)
              .foregroundColor(.accentColor)
              .padding()
          // buttons for restart and fight
          HStack {
              VStack {
                  Text("Restart")
                      .font(.custom("AcademyEngravedLetPlain", size: 34))
                      .fontWeight(.bold)
                      .foregroundColor(.accentColor)
                      .padding()
                  Image("restart")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 100, height: 100, alignment: .center)
                      .padding()
              }
              VStack {
                  Text("Fight")
                      .font(.custom("AcademyEngravedLetPlain", size: 34))
                      .fontWeight(.bold)
                      .foregroundColor(.accentColor)
                      .padding()
                  Image("fight")
                      .resizable()
                      .scaledToFit()
                      .frame(width: 100, height: 100, alignment: .center)
                      .padding()
              }
          }}
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
