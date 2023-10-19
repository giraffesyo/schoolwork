//
//  people.swift
//  Exam2_McQuade_Michael
//
//  Created by Michael McQuade on 10/19/23.
//

import Foundation

struct Findable: Codable, Identifiable {
    var id: Int
    var distance: Int
    var type: String
    var name: String
    var location: String
    var lati: Double
    var longi: Double
}
