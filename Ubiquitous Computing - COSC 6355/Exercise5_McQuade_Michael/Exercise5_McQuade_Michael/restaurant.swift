//
//  restaurant.swift
//  Exercise5_McQuade_Michael
//
//  Created by Michael McQuade on 10/2/23.
//

import Foundation

struct Restaurant: Codable, Identifiable {
  var id: String { name }
  var name: String
  var free: String
  var phone: String
  var logo: URL
  var map: URL
  var lots: String
  var about: String
}
