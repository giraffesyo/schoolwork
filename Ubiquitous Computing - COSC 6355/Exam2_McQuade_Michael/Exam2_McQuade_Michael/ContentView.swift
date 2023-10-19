//
//  ContentView.swift
//  Exam2_McQuade_Michael
//
//  Created by Michael McQuade on 10/19/23.
//

import SwiftUI

let CustomGreen = Color(red: 0, green: 0.365, blue: 0.467)

struct ContentView: View {
  @State private var findables = [Findable]()

  func fetchFindables() async {

    guard
      let url = URL(
        string:
          "https://m.cpl.uh.edu/courses/ubicomp/fall2022/webservice/people.json"
      )
    else {
      print("Invalid URL")
      return
    }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        do {
          let decoder = JSONDecoder()
          let f = try decoder.decode([Findable].self, from: data)
          findables = f.map { findable in
            return Findable(
              id: findable.id,
              distance: findable.distance,
              type: findable.type,
              name: findable.name,
              location: findable.location,
              lati: findable.lati,
              longi: findable.longi
            )
          }
        } catch {
          print("JSON Decode failed")
        }
      } else if let error = error {
        print(error.localizedDescription)
      }
    }
    task.resume()
    print(findables)
  }
  // print people
  // print out the people

  var body: some View {
    VStack {
      Text("Everyone")
        .font(.largeTitle)
        // color blue
        .foregroundColor(.blue)
        .fontWeight(.bold)
      Text("somewhere near me")
        .font(.largeTitle)
        .frame(maxWidth: 200).multilineTextAlignment(.center)
        .foregroundColor(CustomGreen)
        .fontWeight(.bold)
      Spacer()
      // UI Table with all the people
      List(findables) { findable in
        VStack(alignment: .leading) {
          HStack {
            Text(findable.name)
              .font(.system(size: CGFloat(25)))
              .fontWeight(.bold)
            Text("\(findable.distance) miles away")
              .font(.system(size: CGFloat(15)))
              .fontWeight(.bold)
          }
        }
      }
    }.task {
      await fetchFindables()
    }

  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
