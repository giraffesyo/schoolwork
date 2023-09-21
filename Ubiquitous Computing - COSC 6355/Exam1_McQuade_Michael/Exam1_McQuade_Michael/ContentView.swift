//
//  ContentView.swift
//  Exam1_McQuade_Michael
//
//  Created by Michael McQuade on 9/21/23.
//

import SwiftUI

let orangeColor = Color(red: 242 / 255, green: 103 / 255, blue: 28 / 255)
let blueColor = Color(red: 40 / 255, green: 124 / 255, blue: 180 / 255)
struct ContentView: View {
  @State var gameState = GameState(
    gameBoard: [[GamePiece]](repeating: [GamePiece](repeating: GamePiece(), count: 3), count: 3))
  var body: some View {
    // two tabs, Game and Bank
    TabView {
      GameView(gameState: $gameState)
        .tabItem {
          Image(systemName: "gamecontroller")
          Text("Game")
        }
      BankView(gameState: $gameState)
        .tabItem {
          Image(systemName: "dollarsign.circle")
          Text("Bank")
        }
    }
  }
}

struct GameState: Equatable {

  static func == (lhs: GameState, rhs: GameState) -> Bool {
    if lhs.currentCredit != rhs.currentCredit {
      return false
    }
    if lhs.currentBet != rhs.currentBet {
      return false
    }
    // check if all game pieces are equal
    for i in 0..<lhs.gameBoard.count {
      for j in 0..<lhs.gameBoard[i].count {
        if lhs.gameBoard[i][j] != rhs.gameBoard[i][j] {
          return false
        }
      }
    }
    return true
  }

  // gameBoard is array of arrays of 9 game pieces
  var gameBoard: [[GamePiece]]
  var currentCredit: Int = 100
  var currentBet: Int = 1
  var currentWinCount: Int = 0
  var currentPlayCount: Int = 0

  mutating func Play() {
    // check if there is enough credit to play
    if currentCredit < currentBet {
      return
    }
    // generate random game board
    gameBoard = [[GamePiece]](repeating: [GamePiece](repeating: GamePiece(), count: 3), count: 3)
    for i in 0..<gameBoard.count {
      for j in 0..<gameBoard[i].count {
        gameBoard[i][j].value = Bool.random() ? "X" : "O"
      }
    }

    // check if there are three in a row horizontally, vertically, or diagonally, if so the player loses
    // if there are no three in a row, the player wins
    // set "win" on each game piece when the computer wins, so we can show right icon
    var computerWin = true
    for i in 0..<gameBoard.count {
      var rowWin = true
      var colWin = true
      for j in 0..<gameBoard[i].count {
        if gameBoard[i][j].value != "X" {
          rowWin = false
        }
        if gameBoard[j][i].value != "X" {
          colWin = false
        }
      }
      if rowWin || colWin {
        computerWin = false
      }
      if rowWin {
        for j in 0..<gameBoard[i].count {
          gameBoard[i][j].win = true
        }
      }
      if colWin {
        for j in 0..<gameBoard[i].count {
          gameBoard[j][i].win = true
        }
      }
    }

    // player wins 10 * current bet, or loses current bet
    if computerWin {
      currentCredit -= currentBet
    } else {
      currentCredit += currentBet * 10
    }
    currentBet = 1
    currentPlayCount += 1
  }

  mutating func increaseBet() {
    currentBet *= 2
    if currentBet >= 1000 {
      currentBet = 1
    }
  }
}

struct GameView: View {
  @Binding var gameState: GameState
  @Environment(\.verticalSizeClass) var verticalSizeClass
  var body: some View {
    let isLandscape = verticalSizeClass == .compact
    let layout =
      isLandscape ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
    VStack {

      layout {
        Text("!XO in a row")
          .font(.custom("GillSans-Bold", size: 50))
          .foregroundColor(orangeColor).padding(.horizontal)
        HStack {
          Text("Credit: \(gameState.currentCredit)")
            .font(.custom("GillSans", size: 40))
          Text("Bet: \(gameState.currentBet)")
            .font(.custom("GillSans", size: 40))
        }.padding(.vertical)
      }

      layout {
        VStack {
          ForEach(gameState.gameBoard, id: \.self) { row in
            HStack {
              ForEach(row, id: \.self) { piece in
                piece
              }
            }
          }.padding(.vertical)
        }
        HStack {
          Button(
            action: {
              print("Play button pressed")
              gameState.Play()
            },
            label: {
              Text("Play")
                .font(.custom("GillSans", size: 30))
                .foregroundColor(.white)
                .padding()
                .fontWeight(.bold)

            }
          )
          .frame(maxWidth: .infinity)
          .frame(height: 125)
          .background(blueColor)
          Button(
            action: {
              print("Bet button pressed")
              gameState.increaseBet()
            },
            label: {
              HStack {
                Image(systemName: "arrow.up")
                Text("Bet")
                  .font(.custom("GillSans", size: 30))
                  .fontWeight(.bold)

              }.foregroundColor(.white)
                .padding()

            }
          )
          .frame(maxWidth: .infinity)
          .frame(height: 125)
          .background(blueColor)
        }.padding(.horizontal).fixedSize(horizontal: false, vertical: true)
      }

      Spacer()
    }
  }

}

struct BankView: View {
  @Binding var gameState: GameState
  @Environment(\.verticalSizeClass) var verticalSizeClass
  var body: some View {
    let isLandscape = verticalSizeClass == .compact
    let layout =
      isLandscape ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
    layout {
      VStack {
        Text("!XO in a row")
          .font(.custom("GillSans-Bold", size: 50))
          .foregroundColor(orangeColor)
        VStack {
          HStack {

            Text("Spins:")
              .font(.custom("GillSans", size: 40))
            Spacer()
            Text("\(gameState.currentPlayCount)")
              .font(.custom("GillSans", size: 40))
          }.padding(.horizontal)

          HStack {
            Text("Won:")
              .font(.custom("GillSans", size: 40))
            Spacer()
            Text("\(gameState.currentWinCount)")
              .font(.custom("GillSans", size: 40))
          }.padding(.horizontal)
          HStack {
            Text("Credit:")
              .font(.custom("GillSans", size: 40))
            Spacer()
            Text("\(gameState.currentCredit)")
              .font(.custom("GillSans", size: 40))
          }.padding(.horizontal)
        }.padding(.vertical)
        Spacer()
      }.padding(.horizontal)
      VStack {
        HStack {
          TextField("Add Credit", text: .constant(""))
            .font(.custom("GillSans", size: 40))
            .padding()
            .background(Color.white)
            .overlay(
              Rectangle()
                .stroke(Color.gray, lineWidth: 2)
            )
          Text("$")
            .font(.custom("GillSans", size: 40))
            .padding()
            .background(Color.white)
            .padding(.horizontal)

        }.padding().fixedSize(horizontal: false, vertical: true)
        Button(
          action: {
            print("Add credit button pressed")
          },
          label: {
            Text("Add Credit")
              .font(.custom("GillSans", size: 30))
              .foregroundColor(.white)
              .padding()
              .fontWeight(.bold)

          }
        ).frame(maxWidth: .infinity).frame(height: 125).background(blueColor).padding(.horizontal)
        Spacer()
      }
    }
  }
}

let imageLookup: [String: String] = [
  "win_X": "cross_1",
  "win_O": "circle_1",
  "X": "cross_0",
  "O": "circle_0",
]

func getImageName(_ value: String, _ win: Bool) -> String {
  if win {
    return "win_\(value)"
  } else {
    return value
  }
}

struct GamePiece: View, Hashable {

  var id = UUID()
  var value: String = ""
  var win: Bool = false

  var body: some View {
    (value == ""
      ? Image(systemName: "questionmark")
      : Image(imageLookup[getImageName(value, win)]!))
      .resizable()
      //   .frame(width: 50, height: 75)
      .foregroundColor(.blue)
      .background(Color.clear)
      .padding(.horizontal)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
