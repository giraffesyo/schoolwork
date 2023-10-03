//
//  ContentView.swift
//  Exercise5_McQuade_Michael
//
//  Created by Michael McQuade on 10/2/23.
//

import SwiftUI

struct ContentView: View {
  @State private var restaurants = [Restaurant]()

  func fetchRestaurants() async {

    guard
      let url = URL(
        string:
          "https://m.cpl.uh.edu/courses/ubicomp/fall2022/webservice/restaurant/restaurants.json"
      )
    else {
      print("Invalid URL")
      return
    }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        do {
          let decoder = JSONDecoder()
          let r = try decoder.decode([Restaurant].self, from: data)
          // replace http with https on map and logo
        restaurants = r.map { restaurant in
            guard
              let logo = URL(
                string:
                  restaurant.logo.absoluteString.replacingOccurrences(
                    of: "http://",
                    with: "https://"
                  )),
              let map = URL(
                string:
                  restaurant.map.absoluteString.replacingOccurrences(
                    of: "http://",
                    with: "https://"
                  ))
            else {
              return restaurant
            }
            return Restaurant(
              name: restaurant.name,
              free: restaurant.free,
              phone: restaurant.phone,
              logo: logo,
              map: map,
              lots: restaurant.lots,
              about: restaurant.about
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

  }

  var body: some View {
    VStack {
      List(restaurants) { restaurant in
        //                        NavigationLink(destination: RestaurantDetail(restaurant: restaurant)) {
        RestaurantRow(restaurant: restaurant)
        //                        }
      }.task {
        await fetchRestaurants()
      }
    }
  }
}

struct RestaurantRow: View {
  var restaurant: Restaurant

  var body: some View {
    HStack {
      AsyncImage(url: restaurant.logo) { image in
        image.resizable()
      } placeholder: {
        ProgressView()
      }
      Text(restaurant.name)
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
