import SwiftUI

struct HistoryView: View {
  @EnvironmentObject var store: Store

  var body: some View {
    // show text label for today, yesterday, or date for other days
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: Date())
    let yesterday = dateFormatter.string(from: Date().addingTimeInterval(-86400))

    return VStack {
      HStack {
        Text("History")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
      }
      if store.history.count > 0 {
        NavigationStack {
          ForEach(store.workoutsByDate.keys.sorted(by: >), id: \.self) { day in
            let dayString = dateFormatter.string(from: day)
            let label =
              dayString == today
              ? "Today"
              : dayString == yesterday
                ? "Yesterday"
                : dayString

            // List of dates, and list of workouts under each date
            Text(label)
              .font(.title)
              .fontWeight(.bold)
              .foregroundColor(.white)
            HistoryDayView(workouts: store.workoutsByDate[day]!)
          }
        }
      } else {
        NoHistoryView()
      }
    }
  }
}

struct HistoryDayView: View {
  var workouts: [Workout]

  var body: some View {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"
    return VStack {

      List {
        ForEach(workouts) { workout in
          // only show time
          let time = dateFormatter.string(from: workout.startedAt)
          NavigationLink(destination: TODOView()) {
            HStack {
              Text("\(workout.exercises.count) exercises")
              Spacer()
              VStack {
                Text("\(time)")
                Text("\(workout.duration)")
              }
            }
          }
        }
      }

    }
  }
}

struct NoHistoryView: View {
  var body: some View {
    VStack {
      Spacer()
      Text("No history yet")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.white)

      Spacer()
    }
  }
}

struct HistoryView_Previews: PreviewProvider {

  static var previews: some View {
    ContentView(selectedTab: 2)
  }
}

struct HistoryMultipleDays_Previews: PreviewProvider {

  static var previews: some View {
    ContentView(selectedTab: 2)
  }
}
