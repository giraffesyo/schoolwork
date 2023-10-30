import SwiftUI

struct Days {
  static let Monday: String = "Mo"
  static let Tuesday: String = "Tu"
  static let Wednesday: String = "We"
  static let Thursday: String = "Th"
  static let Friday: String = "Fr"
  static let Saturday: String = "Sa"
  static let Sunday: String = "Su"
  static let all: [String] = [
    Days.Sunday,
    Days.Monday,
    Days.Tuesday,
    Days.Wednesday,
    Days.Thursday,
    Days.Friday,
    Days.Saturday,
  ]
}

func checkIfExercisedOn(day: String, exercisedDays: ExercisedDays) -> Bool {
  switch day {
  case Days.Monday:
    return exercisedDays.Monday
  case Days.Tuesday:
    return exercisedDays.Tuesday
  case Days.Wednesday:
    return exercisedDays.Wednesday
  case Days.Thursday:
    return exercisedDays.Thursday
  case Days.Friday:
    return exercisedDays.Friday
  case Days.Saturday:
    return exercisedDays.Saturday
  case Days.Sunday:
    return exercisedDays.Sunday
  default:
    return false
  }
}

struct WeeklyGoalsView: View {
  @EnvironmentObject var store: Store
  var body: some View {
    let exercisedDays = store.getExercisedDaysThisWeek()
    print(exercisedDays)
    return HStack {

      ForEach(Days.all, id: \.self) { day in

        DayView(day: day, exercised: checkIfExercisedOn(day: day, exercisedDays: exercisedDays))
      }
    }
  }
}

struct GoalsView: View {
  @EnvironmentObject var store: Store
  var body: some View {

    VStack {
      HStack {
        Text("Goals")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
      }
      WeeklyGoalsView()
      Spacer()

      Text("Current Streak")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.white)

      Text("0 weeks")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.white)
      Spacer()

      // This is a button that will allow the user to change their goal
      // to a different number of days per week.
      Button(action: {
        print("Change goal")
      }) {
        VStack {
          Text("Current Goal")
            .font(.title)
            .fontWeight(.bold)
            .foregroundColor(.white)

          HStack {
            Text("1")
              .font(.title)
              .fontWeight(.bold)
              .foregroundColor(.accentColor)
            Text("day per week")
              .font(.title)
              .fontWeight(.bold)
              .foregroundColor(.white)
          }
        }
      }

      Spacer()
    }
  }
}

struct DayView: View {
  var day = ""
  var exercised = false
  var body: some View {
    VStack {
      Circle()
        .frame(width: 10, height: 10)
        .foregroundColor(exercised ? .accentColor : .black)
      Text(day).foregroundColor(exercised ? .accentColor : .gray)
    }
  }
}

struct GoalsView_Previews: PreviewProvider {

  static var previews: some View {
    ContentView(selectedTab: 1)
  }
}

struct GoalsViewWithWorkouts_Previews: PreviewProvider {

  static let mock_store = Store()

  static var previews: some View {
    mock_store.emptyHistory()
    mock_store.addWorkout(
      workout: Workout(startedAt: Date(), endedAt: Date().addingTimeInterval(3700)))
    mock_store.addWorkout(
      workout: Workout(
        startedAt: Date().addingTimeInterval(-86400),
        endedAt: Date().addingTimeInterval(-86400 + 3000)))
    mock_store.addWorkout(
      workout: Workout(
        startedAt: Date().addingTimeInterval(-86400 * 2),
        endedAt: Date().addingTimeInterval(-86400 * 2 + 3600)))
    return ContentView(selectedTab: 1, store: mock_store)
  }
}
