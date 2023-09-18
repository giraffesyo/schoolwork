//
//  ContentView.swift
//  Exercise4_McQuade_Michael
//
//  Created by Michael McQuade on 9/17/23.
//

import SwiftUI

var brownColor = Color(red: 98 / 255, green: 85 / 255, blue: 84 / 255, opacity: 1.0)
var customFont: String = "AcademyEngravedLetPlain"

let dragons: [Dragon] = [
  Dragon(name: "Balerion", image: "dragon-balerion", power: 10000),
  Dragon(name: "Meraxes", image: "dragon-meraxes", power: 1000),
  Dragon(name: "Sheepstealer", image: "dragon-sheepstealer", power: 950),
  Dragon(name: "Silverwing", image: "dragon-silverwing", power: 900),
  Dragon(name: "Meleys", image: "dragon-meleys", power: 890),
  Dragon(name: "Quicksilver", image: "dragon-quicksilver", power: 880),
  Dragon(name: "Stormcloud", image: "dragon-stormcloud", power: 100),
  Dragon(name: "Drogon", image: "dragon-drogon", power: 50),
  Dragon(name: "Viserion", image: "dragon-viserion", power: 25),
]
struct Dragon {
  var name: String
  var image: String
  var power: Int
}
struct Player {
  var name: String
  var score: Int
  var image: String

  mutating func resetScore() {
    score = 0
  }
  mutating func incrementScore() {
    score += 1
  }
}

struct GameState {
  var player1: Player = Player(name: "Player 1", score: 0, image: "dragon-placeholder")
  var player2: Player = Player(name: "Player 2", score: 0, image: "dragon-placeholder")
  var gameStatus: String = "Prepare for the battle!"
  var gameOver: Bool = false

  mutating func fightButtonPressed() {
    print("Fight button pressed")
    if gameOver {
      print("Game is over, restart to play again")
      return
    }
    let player1Dragon = dragons.randomElement()!
    var player2Dragon = dragons.randomElement()!
    while player1Dragon.name == player2Dragon.name {
      player2Dragon = dragons.randomElement()!
    }
    // compare dragons and update game status
    if player1Dragon.power > player2Dragon.power {
      gameStatus = "\(player1Dragon.name) is stronger!\n \(player1.name) wins"
      player1.incrementScore()
    } else if player1Dragon.power < player2Dragon.power {
      gameStatus = "\(player2Dragon.name) is stronger!\n \(player2.name) wins"
      player2.incrementScore()
    }
    // game is over if either player has 3 points
    if player1.score == 3 {
      gameStatus = "\(player1.name) won (\(player1.score) - \(player2.score))!\n Restart the game."
      gameOver = true
    } else if player2.score == 3 {
      gameStatus = "\(player2.name) won (\(player2.score) - \(player1.score))!\n Restart the game."
      gameOver = true
    }
    // update player images
    player1.image = player1Dragon.image
    player2.image = player2Dragon.image
  }

  mutating func restartButtonPressed() {
    print("Restart button pressed")
    gameOver = false
    player1.resetScore()
    player2.resetScore()
    gameStatus = "Prepare for the battle!"
    player1.image = "dragon-placeholder"
    player2.image = "dragon-placeholder"
  }
}

struct ContentView: View {
  @State var gameState: GameState = GameState()
  // read orientation from environment
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
  var body: some View {
    VStack {
      TabView {

        GameView(
          gameState: $gameState
        )
        .tabItem({
          Image("fire_off")
          Text("Game")
        })
          ScoreView(
            player1: gameState.player1,
            player2: gameState.player2
          ).tabItem({
            Image("score_off")
            Text("Score")
          })
      }
    }
  }
}

struct GameView: View {

  @Binding var gameState: GameState

  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  var body: some View {
    let layout =
      horizontalSizeClass == .compact ? AnyLayout(VStackLayout()) : AnyLayout(HStackLayout())

    VStack {
      Image("logo-text")
        .resizable()
        .scaledToFit()
        .imageScale(.large)
        .foregroundColor(.accentColor)
        .padding()
      HStack {
        PlayerView(player: gameState.player1)
        PlayerView(player: gameState.player2)
      }
      Spacer()
      Text(gameState.gameStatus)
        .font(.custom(customFont, size: 34))
        .multilineTextAlignment(.center)
        .fontWeight(.bold)
        .foregroundColor(brownColor)
        .padding()
      Spacer()
      HStack {
        Button(action: { gameState.restartButtonPressed() }) {
          VStack {
            Text("Restart")
              .font(.custom(customFont, size: 34))
              .fontWeight(.bold)
              .foregroundColor(brownColor)
            Image("restart")
              .resizable()
              .scaledToFit()
              .frame(width: 125, height: 125, alignment: .center)
          }
        }

        Button(action: { gameState.fightButtonPressed() }) {
          VStack {
            Text("Fight")
              .font(.custom(customFont, size: 34))
              .fontWeight(.bold)
              .foregroundColor(brownColor)
            Image("fight")
              .resizable()
              .scaledToFit()
              .frame(width: 125, height: 125, alignment: .center)
          }
        }.opacity(Double(gameState.gameOver ? 0.25 : 1.0)).disabled(gameState.gameOver)

      }
    }
  }
}

struct ScoreView: View {
  var player1: Player
  var player2: Player
  @Environment(\.verticalSizeClass) var verticalSizeClass
    
  var body: some View {
      let isLandscape = verticalSizeClass == .compact
    let layout =
      isLandscape ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
    return VStack(alignment: .center) {
      Image("logo-text")
        .resizable()
        .scaledToFit()
        .imageScale(.large)
        .foregroundColor(.accentColor)
      layout {
        PlayerScore(player: player1)
        PlayerScore(player: player2)
      }
      Spacer()
    }
    .padding()

  }
}

struct PlayerScore: View {
  var player: Player
  var body: some View {
    VStack(alignment: .center) {

      Text(player.name)
        .font(.custom(customFont, size: 34))
        .fontWeight(.bold)
        .foregroundColor(brownColor)
      HStack {
        Image("dragon-placeholder")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100, alignment: .center)
          .opacity(player.score >= 1 ? 1 : 0.25)
        Image("dragon-placeholder")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100, alignment: .center)
          .opacity(player.score >= 2 ? 1 : 0.25)
        Image("dragon-placeholder")
          .resizable()
          .scaledToFit()
          .frame(width: 100, height: 100, alignment: .center)
          .opacity(player.score >= 3 ? 1 : 0.25)
      }.padding(.horizontal)
    }
  }
}

struct PlayerView: View {
  var player: Player
  var body: some View {
    VStack {
      Text(player.name)
        .font(.custom(customFont, size: 34))
        .fontWeight(.bold)
        .foregroundColor(brownColor)
      Image(player.image)
        .resizable()
        .scaledToFit().frame(width: 150, height: 150)
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
