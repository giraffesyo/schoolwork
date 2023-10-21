import SwiftUI

struct Workout: Identifiable {
  var id = UUID()
  var startedAt: Date
  var endedAt: Date?
}

enum ExerciseType {
  case sets
  case time
}

struct Exercise: Identifiable {
  var id = UUID()
  var name: String
  var description: String
  var image: Image?
  var type: ExerciseType
}
