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

struct Card {
    var title: String
    var image: UIImage?
    var bulletPoints: [String]
}

struct ContentView: View {
    
    // array of cards
    var cards: [Card] = [
        Card(title: "test", image: UIImage(named: "1"), bulletPoints: ["test", "test"]),
    ]

    @State private var currentCardIndex = 0

    func nextCard() {
        currentCardIndex += 1
        if currentCardIndex >= cards.count {
            currentCardIndex = 0
        }
    }

    func randomCard() {
        currentCardIndex = Int.random(in: 0..<cards.count)
    }


    var body: some View {
        VStack {
            Text("CardHub")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding() 
                .foregroundColor(.brown)
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Button(action: randomCard, label: {
                Text("Random Card").padding().fontWeight(.bold).foregroundColor(.white)
            }) // #eec292 hex color is tan
            .background(Color(red: 238/255, green: 194/255, blue: 146/255))
            Button(action: nextCard, label: {
                Text("Next Card").padding().fontWeight(.bold).foregroundColor(.white)
            }) // #f2671c hex color is orange
            .background(Color(red: 242/255, green: 103/255, blue: 28/255))
            
            Button(action: {}, label: {
                Text("Card Selector").padding().fontWeight(.bold).foregroundColor(.white)
            }) // #8e4235 hex color is brown
            .background(Color(red: 142/255, green: 66/255, blue: 53/255))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
