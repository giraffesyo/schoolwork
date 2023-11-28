import SwiftUI

/// ExercisedDays is a struct that contains a boolean for each day of the week.
/// It is used to determine which days have been exercised on in the current week.
struct ExercisedDays {
  var Monday: Bool = false
  var Tuesday: Bool = false
  var Wednesday: Bool = false
  var Thursday: Bool = false
  var Friday: Bool = false
  var Saturday: Bool = false
  var Sunday: Bool = false
}

/// The store is the single source of truth for the application.
/// All data is stored in the store, and all views are updated when the store changes.
/// The store is loaded from UserDefaults when the app starts, and continuously saved to UserDefaults as it changes.
/// The store is an ObservableObject, so views can subscribe to changes in the store.
/// The store is also an Actor, so it can be accessed from multiple threads.
/// This also allows us to pass a mocked store to views for testing, which is utilized in the previews.
@MainActor
class Store: ObservableObject {

  /// history_key is the key used to store the history in UserDefaults.
  let history_key: String = "history"
  /// exercises_key is the key used to store the exercises in UserDefaults.
  let exercises_key: String = "exercises"
  /// goals_key is the key used to store the goals in UserDefaults.
  let goals_key: String = "goals"
  @Published var history: [Workout]
  @Published var exercises: [ExerciseMetadata]
  /// When set, forces the user to navigate to the CompletedWorkoutOverview view.
  @Published var presentingWorkout: Workout?
  /// Given an integer, sets the goal for the number of workouts per week.
  @Published var goals: Int {
    didSet {
      UserDefaults.standard.set(goals, forKey: goals_key)
    }
  }

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
    if let goals = UserDefaults.standard.object(forKey: goals_key) as? Int {
      self.goals = goals
    } else {
      self.goals = 3
    }
  }

  /// Saves the store to UserDefaults.
  private func save() {
    if let encoded = try? JSONEncoder().encode(history) {
      UserDefaults.standard.set(encoded, forKey: history_key)
    }
    if let encoded = try? JSONEncoder().encode(exercises) {
      UserDefaults.standard.set(encoded, forKey: exercises_key)
    }
  }

  /// Given an exercise, adds it to the list of exercises.
  func addExercise(exercise: ExerciseMetadata) {
    exercises.append(exercise)
    save()
  }

  /// Given an exercise, removes it from the list of exercises.
  func removeExercise(exercise: ExerciseMetadata) {
    exercises.removeAll(where: { $0.id == exercise.id })
    save()
  }

  /// Given a workout, adds it to the history.
  func addWorkout(workout: Workout) {
    history.append(workout)
    save()
  }
  /// Given a workout, removes it from the history.
  func removeWorkout(workout: Workout) {
    history.removeAll(where: { $0.id == workout.id })
    save()
  }
  /// Removes all workouts from the history.
  func emptyHistory() {
    history = []
    save()
  }

}

/// A workout is a collection of exercises that are performed together.
/// A workout can be started and ended, and the duration is calculated.
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

/// The type of exercise, which determines how it is tracked and displayed.
enum ExerciseType: String, Codable {
  case bodyweight_sets = "Bodyweight"
  case time = "Timed"
  case weighted_sets = "Weighted"
}

/// An exercise is the smallest unit that composes a workout.
struct Exercise: Identifiable, Codable {
  var id = UUID()
  var metadata: ExerciseMetadata
  var sets: Int = 0
  var weight: Int = 0
  var startedAt: Date = Date()
  var endedAt: Date?
  // calculated duration (DateInterval)
  var duration: String {
    let interval = DateInterval(start: startedAt, end: endedAt ?? Date())
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .abbreviated
    return formatter.string(from: interval.duration)!
  }

  /// Increments the number of sets for this exercise.
  mutating func incrementSets() {
    self.sets = sets + 1
  }

  /// Decrements the number of sets for this exercise, but only if the number of sets is greater than 0.
  mutating func decrementSets() {
    if sets > 0 {
      self.sets = sets - 1
    }
  }
}

/// The metadata for an exercise, which is used to display information about the exercise.
struct ExerciseMetadata: Identifiable, Codable {
  var id = UUID()
  var name: String
  var description: String
  var customImage: Bool
  var image: String
  var type: ExerciseType

}

/// A preset array of exercises that are used to populate the initial list of exercises when the app is first installed.
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
