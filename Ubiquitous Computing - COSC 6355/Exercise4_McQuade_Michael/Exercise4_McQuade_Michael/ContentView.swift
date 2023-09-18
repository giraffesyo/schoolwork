//
//  ContentView.swift
//  Exercise4_McQuade_Michael
//
//  Created by Michael McQuade on 9/17/23.
//

import SwiftUI

struct ContentView: View {
  var player1Name: String = "Player 1"
  var player1Score: Int = 0
  var player2Name: String = "Player 2"
  var player2Score: Int = 0
  var gameStatus: String = "Prepare for the battle!"

  var body: some View {
    VStack {
      Image("logo-text")
        .resizable()
        .scaledToFit()
        .imageScale(.large)
        .foregroundColor(.accentColor)
        .padding()
      TabView {
        GameView(
          gameStatus: gameStatus, player1Name: player1Name, player1Score: player1Score,
          player2Name: player2Name, player2Score: player2Score
        )
        .tabItem({
          Image("fire_off")
          Text("Game")
        })
        ScoreView(
          player1Name: player1Name, player1Score: player1Score, player2Name: player2Name,
          player2Score: player2Score
        ).tabItem({
          Image("score_off")
          Text("Score")
        })
      }
    }
  }
}

struct GameView: View {
  var gameStatus: String
  var player1Name: String
  var player1Score: Int
  var player2Name: String
  var player2Score: Int
  var body: some View {
    VStack {
      HStack {
        PlayerView(playerName: player1Name)
        PlayerView(playerName: player2Name)
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
      }
    }
  }
}

struct ScoreView: View {
  var player1Name: String
  var player1Score: Int = 0
  var player2Name: String
  var player2Score: Int = 0
  var body: some View {
    VStack {
      PlayerScore(playerName: player1Name, playerScore: player1Score)
      PlayerScore(playerName: player2Name, playerScore: player2Score)
    }
  }
}

struct PlayerScore: View {
  var playerName: String
  var playerScore: Int
  var body: some View {
    VStack {
      Text(playerName)
        .font(.custom("AcademyEngravedLetPlain", size: 34))
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
        .padding()
      HStack {
        // 3 dragon placeholder icons in a horizontal stack, each point fills in one dragon
        Image("dragon-placeholder")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100, alignment: .center)
          .padding()
          .opacity(playerScore >= 1 ? 1 : 0.25)
        Image("dragon-placeholder")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100, alignment: .center)
          .padding()
          .opacity(playerScore >= 2 ? 1 : 0.25)
        Image("dragon-placeholder")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100, alignment: .center)
          .padding()
          .opacity(playerScore >= 3 ? 1 : 0.25)
      }
    }
  }
}

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
