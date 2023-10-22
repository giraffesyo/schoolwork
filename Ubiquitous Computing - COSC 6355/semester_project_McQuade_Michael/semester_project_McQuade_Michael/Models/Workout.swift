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

enum ExerciseType: String {
  case bodyweight_sets = "Bodyweight"
  case time = "Timed"
  case weighted_sets = "Weighted"
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

// preset array of exercises for testing

struct PRELOADED_EXERCISES {
  static let pushups = ExerciseMetadata(
    name: "Pushups",
    description: "Pushups are a great exercise for your chest and arms.",
    image: Image("pushup"),
    type: .bodyweight_sets
  )

  static let plank = ExerciseMetadata(
    name: "Plank",
    description: "Planks are a great exercise for your core.",
    image: Image("pushup"),
    type: .time
  )

  static let eliptical = ExerciseMetadata(
    name: "Eliptical",
    description:
      "Eliptical is a great exercise for your legs and arms, as well as excellent cardio. It is also low impact, so it is easy on your joints compared to running.",
    image: Image("eliptical"),
    type: .time
  )

  static let curl = ExerciseMetadata(
    name: "Bicep Curl",
    description: "Bicep curls are a great exercise for your biceps.",
    image: Image("bicepcurl"),
    type: .weighted_sets
  )

  static let situp = ExerciseMetadata(
    name: "Situp",
    description: "Situps are a great exercise for your core.",
    image: Image("situp"),
    type: .bodyweight_sets
  )
  static let all = [pushups, plank, eliptical, curl, situp]
}
