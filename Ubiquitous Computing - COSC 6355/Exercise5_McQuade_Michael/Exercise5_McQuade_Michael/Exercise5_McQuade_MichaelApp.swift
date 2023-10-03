//
//  Exercise5_McQuade_MichaelApp.swift
//  Exercise5_McQuade_Michael
//
//  Created by Michael McQuade on 10/2/23.
//

import SwiftUI

struct Response: Codable {
  var restaurants: [Restaurant]
}

@main
struct Exercise5_McQuade_MichaelApp: App {

  var body: some Scene {
    WindowGroup {
      ContentView()
    }
  }
}
