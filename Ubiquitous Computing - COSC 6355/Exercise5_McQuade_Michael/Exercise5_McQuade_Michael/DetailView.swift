//
//  DetailView.swift
//  Exercise5_McQuade_Michael
//
//  Created by Michael McQuade on 10/2/23.
//

import SwiftUI

struct RestaurantDetail: View {
  var restaurant: Restaurant
  @Environment(\.verticalSizeClass) var verticalSizeClass
  var body: some View {
    let isLandscape = verticalSizeClass == .compact
    let layout =
      isLandscape ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())
    layout {
      AsyncImage(url: restaurant.map) { image in
        image
          .resizable()
          .aspectRatio(contentMode: .fit)

      } placeholder: {
        ProgressView()
      }
      VStack {
        AsyncImage(url: restaurant.logo) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 75)
        } placeholder: {
          ProgressView()
        }

        Text(restaurant.name)
          .padding().bold()
        Text(restaurant.about).multilineTextAlignment(.center).padding(.horizontal)
        Text(restaurant.phone)

      }
    }
  }
}
