//
//  ContentView.swift
//  Exercise2_McQuade_Michael
//
//  Created by Michael McQuade on 9/4/23.
//

import SwiftUI

// cards are literals in an array,
// have a card title, which is a string
// card image,
// and card bullet points, which is an array of strings
// #eec292 hex color is tan
let tanColor = Color(red: 238 / 255, green: 194 / 255, blue: 146 / 255)
// #f2671c hex color is orange
let orangeColor = Color(red: 242 / 255, green: 103 / 255, blue: 28 / 255)
// #8e4235 hex color is brown
let brownColor = Color(red: 142 / 255, green: 66 / 255, blue: 53 / 255)
// #b4bec8 hex color is gray
let grayColor = Color(red: 180 / 255, green: 190 / 255, blue: 200 / 255)
let buttonTextColor = Color(.white)
let imageSize = 64.0

struct Card: Identifiable, Equatable, Hashable {
  static func == (lhs: Card, rhs: Card) -> Bool {
    return lhs.id == rhs.id
  }
  var id = UUID()
  var title: String
  var image: UIImage?
  var bulletPoints: [String]
}

struct ContentView: View {
  let fontWeight = Font.Weight.black
  // array of cards
  @State private var cards: [Card] = [
    Card(
      title: "View Controller", image: UIImage(named: "1"),
      bulletPoints: [
        "defines the behavior for common VCs", "updates the content of the view",
        "responding to user interactions", "resizing views and layout mgmnt",
        "coordinating with other objects",
      ]),
    Card(
      title: "UIKit", image: UIImage(named: "2"),
      bulletPoints: [
        "provides required iOS infrastructure", "window and view architecture",
        "event handling for multi-touch and etc", "manages interaction with system",
        "a lot of features incl. resource management",
      ]),
    Card(
      title: "UIAlertController", image: UIImage(named: "3"),
      bulletPoints: [
        "configure alerts and action sheets", "intended to be used as-is",
        "does not support subclassing", "inherits from UIViewController",
        "support text fields to the alert interface",
      ]),
  ]

  @State private var currentCardIndex = 0
  @State private var showCardSelector = false
  @State private var isShowingAddBulletSheet = false

  func nextCard() {
    currentCardIndex += 1
    if currentCardIndex >= cards.count {
      currentCardIndex = 0
    }
  }

  func getCurrentCard() -> Card {
    return cards[currentCardIndex]
  }

  func randomCard() {
    currentCardIndex = Int.random(in: 0..<cards.count)
  }

  var body: some View {

    VStack {
      Text("CardHub")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(orangeColor)
        .padding()

      Image(uiImage: getCurrentCard().image ?? UIImage()).resizable().frame(
        width: imageSize, height: imageSize
      )
      .foregroundColor(.accentColor)
      Text("Card: " + getCurrentCard().title)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .background(orangeColor)

      VStack {
        ForEach(getCurrentCard().bulletPoints, id: \.self) { bulletPoint in
          Text("☆" + bulletPoint)
            .padding(.bottom, 20.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundColor(.black)
        }
      }
      .background(grayColor)
      Spacer()

      Button(
        action: nextCard,
        label: {
          Text("Next card").padding().fontWeight(fontWeight).foregroundColor(buttonTextColor).frame(
            maxWidth: .infinity)
        }
      )
      .background(orangeColor)

      Button(
        action: {
          showCardSelector = true
        },
        label: {
          Text("Card selector").padding().fontWeight(fontWeight).foregroundColor(buttonTextColor)
            .frame(maxWidth: .infinity)
        }
      )
      .background(brownColor).confirmationDialog(
        "Select a card", isPresented: $showCardSelector, titleVisibility: .visible
      ) {
        ForEach(cards, id: \.self) { card in
          Button(
            action: {
              if let index = cards.firstIndex(of: card) {
                currentCardIndex = index
              }
            },
            label: {
              Text(card.title)
            })
        }
      }

      Button(action: { isShowingAddBulletSheet.toggle() }) {
        Text("Add bullet").padding().fontWeight(fontWeight).foregroundColor(buttonTextColor).frame(
          maxWidth: .infinity
        )
        .background(tanColor)
      }
      .sheet(
        isPresented: $isShowingAddBulletSheet
      ) {
        AddBulletView(
          isShowingAddBulletSheet: $isShowingAddBulletSheet,
          card: $cards[currentCardIndex])
      }

      Button(
        action: randomCard,
        label: {
          Text("Edit card name").padding().fontWeight(fontWeight).foregroundColor(buttonTextColor)
            .frame(maxWidth: .infinity)
        }
      )
      .background(tanColor)
      Spacer()
    }
    .padding(.horizontal, 20.0)

  }
}

struct AddBulletView: View {

  @Binding var isShowingAddBulletSheet: Bool
  @Binding var card: Card
  @State private var bulletText = "New bullet"
  let fontWeight = Font.Weight.black
  var body: some View {
    VStack {
      Text("ADD BULLET")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(orangeColor)
      Text("Card: " + card.title)
        .font(.title2)
        .frame(maxWidth: .infinity)
        .fontWeight(.bold)
        .foregroundColor(.white)
        .background(orangeColor)

      TextField("New bullet text", text: $bulletText)
        .padding(.bottom, 20.0)
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundColor(.black)

        .background(grayColor)

      Button(
        action: {
          print(
            "adding bullet \(bulletText) to card \(card.title) which has \(card.bulletPoints.count) bullets"
          )
            
          card.bulletPoints.append(bulletText)
          isShowingAddBulletSheet.toggle()
        },
        label: {
          Text("Save").padding().fontWeight(fontWeight).foregroundColor(buttonTextColor).frame(
            maxWidth: .infinity)
        }
      )
      .background(brownColor)

      Button(
        action: {
          isShowingAddBulletSheet.toggle()
        },
        label: {
          Text("Cancel").padding()
            .foregroundColor(buttonTextColor)
            .frame(maxWidth: .infinity)
            .fontWeight(fontWeight)
        }
      ).background(tanColor)
      Spacer()
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
