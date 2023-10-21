import SwiftUI

struct Workout: Identifiable {
  var id = UUID()
  var startedAt: Date
  var endedAt: Date?
  var currentExercise: Exercise?
  mutating func endExercise() {
    currentExercise?.endedAt = Date()
    // TODO: Save exercise to history
    currentExercise = nil
  }
}

enum ExerciseType {
  case sets
  case time
}

struct Exercise: Identifiable {
  var id = UUID()
  var metadata: ExerciseMetadata
  var sets: Int?
  var startedAt: Date?
  var endedAt: Date?
}

struct ExerciseMetadata: Identifiable {
  var id = UUID()
  var name: String
  var description: String
  var image: Image?
  var type: ExerciseType
}
