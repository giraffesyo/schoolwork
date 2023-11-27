import SwiftUI

struct ExercisedDays {
  var Monday: Bool = false
  var Tuesday: Bool = false
  var Wednesday: Bool = false
  var Thursday: Bool = false
  var Friday: Bool = false
  var Saturday: Bool = false
  var Sunday: Bool = false
}

@MainActor
class Store: ObservableObject {

  let history_key: String = "history"
  let exercises_key: String = "exercises"
  @Published var history: [Workout]
  @Published var exercises: [ExerciseMetadata]
  func getExercisedDaysThisWeek() -> ExercisedDays {
    var exercisedDays = ExercisedDays()

    let today = Calendar.current.startOfDay(for: Date())
    let thisWeek = Calendar.current.dateInterval(of: .weekOfYear, for: today)!
    for workout in history {
      if thisWeek.contains(workout.startedAt) {
        let day = Calendar.current.component(.weekday, from: workout.startedAt)
        switch day {
        case 1:
          exercisedDays.Sunday = true
        case 2:
          exercisedDays.Monday = true
        case 3:
          exercisedDays.Tuesday = true
        case 4:
          exercisedDays.Wednesday = true
        case 5:
          exercisedDays.Thursday = true
        case 6:
          exercisedDays.Friday = true
        case 7:
          exercisedDays.Saturday = true
        default:
          break
        }
      }
    }
    return exercisedDays
  }
  var workoutsByDate: [Date: [Workout]] {
    var workoutsByDate: [Date: [Workout]] = [:]
    for workout in history {
      let date = Calendar.current.startOfDay(for: workout.startedAt)
      if workoutsByDate[date] == nil {
        workoutsByDate[date] = []
      }
      workoutsByDate[date]!.append(workout)
    }
    return workoutsByDate
  }
  init() {
    if let data = UserDefaults.standard.data(forKey: history_key) {
      if let decoded = try? JSONDecoder().decode([Workout].self, from: data) {
        history = decoded
      } else {
        // we had data, but it was corrupted, so use empty history
        history = []
      }
    } else {
      // we didn't have any saved data, so use empty history
      history = []
    }
    if let data = UserDefaults.standard.data(forKey: exercises_key) {
      if let decoded = try? JSONDecoder().decode([ExerciseMetadata].self, from: data) {
        exercises = decoded
      } else {
        // we had data, but it was corrupted, so use preset exercises
        exercises = PRELOADED_EXERCISES.all
      }
    } else {
      // we didn't have any saved data, so use preset exercises
      exercises = PRELOADED_EXERCISES.all
    }
  }

  private func save() {
    if let encoded = try? JSONEncoder().encode(history) {
      UserDefaults.standard.set(encoded, forKey: history_key)
    }
    if let encoded = try? JSONEncoder().encode(exercises) {
      UserDefaults.standard.set(encoded, forKey: exercises_key)
    }
  }

  func addExercise(exercise: ExerciseMetadata) {
    exercises.append(exercise)
    save()
  }

  func removeExercise(exercise: ExerciseMetadata) {
    exercises.removeAll(where: { $0.id == exercise.id })
    save()
  }

  func addWorkout(workout: Workout) {
    history.append(workout)
    save()
  }

  func removeWorkout(workout: Workout) {
    history.removeAll(where: { $0.id == workout.id })
    save()
  }

  func emptyHistory() {
    history = []
    save()
  }

}

struct Workout: Identifiable, Codable {
  var id = UUID()
  var startedAt: Date
  var endedAt: Date?
  var exercises: [Exercise] = []
  // calculated duration (DateInterval)
  var duration: String {
    let interval = DateInterval(start: startedAt, end: endedAt ?? Date())
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .abbreviated
    return formatter.string(from: interval.duration)!
  }

  var currentExercise: Exercise?
  mutating func endExercise() {
    currentExercise?.endedAt = Date()
    exercises.append(currentExercise!)
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
  var sets: Int = 0
  var weight: Int = 0
  var startedAt: Date?
  var endedAt: Date?

  /**
   Increments the number of sets for this exercise.
   */
  mutating func incrementSets() {
    self.sets = sets + 1
  }
  /**
   Decrements the number of sets for this exercise, but only if the number of sets is greater than 0.
   */
  mutating func decrementSets() {
    if sets > 0 {
      self.sets = sets - 1
    }
  }
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
