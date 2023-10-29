import SwiftUI

struct Store: Codable {
  var history: [Workout]
}

struct Workout: Identifiable, Codable {
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

enum ExerciseType: String, Codable {
  case bodyweight_sets = "Bodyweight"
  case time = "Timed"
  case weighted_sets = "Weighted"
}

struct Exercise: Identifiable, Codable {
  var id = UUID()
  var metadata: ExerciseMetadata
  var sets: Int?
  var weight: Int?
  var startedAt: Date?
  var endedAt: Date?
}

struct ExerciseMetadata: Identifiable, Codable {
  var id = UUID()
  var name: String
  var description: String
  var customImage: Bool
  var image: String
  var type: ExerciseType

}

// preset array of exercises for testing

struct PRELOADED_EXERCISES {
  static let pushups = ExerciseMetadata(
    name: "Pushups",
    description: "Pushups are a great exercise for your chest and arms.",
    customImage: false,
    image: "pushup",
    type: .bodyweight_sets
  )

  static let plank = ExerciseMetadata(
    name: "Plank",
    description: "Planks are a great exercise for your core.",
    customImage: false,
    image: "pushup",
    type: .time
  )

  static let eliptical = ExerciseMetadata(
    name: "Eliptical",
    description:
      "Eliptical is a great exercise for your legs and arms, as well as excellent cardio. It is also low impact, so it is easy on your joints compared to running.",
    customImage: false,
    image: "eliptical",
    type: .time
  )

  static let curl = ExerciseMetadata(
    name: "Bicep Curl",
    description: "Bicep curls are a great exercise for your biceps.",
    customImage: false,
    image: "bicepcurl",
    type: .weighted_sets
  )

  static let situp = ExerciseMetadata(
    name: "Situp",
    description: "Situps are a great exercise for your core.",
    customImage: false,
    image: "situp",
    type: .bodyweight_sets
  )
  static let all = [pushups, plank, eliptical, curl, situp]
}
