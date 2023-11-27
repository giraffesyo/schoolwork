import SwiftUI

struct HistoryView: View {
  @EnvironmentObject var store: Store
  @State private var showDeleteAlert = false
  func delete(workout: Workout) {
    store.removeWorkout(workout: workout)
  }

  var body: some View {
    // show text label for today, yesterday, or date for other days
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd"
    let today = dateFormatter.string(from: Date())
    let yesterday = dateFormatter.string(from: Date().addingTimeInterval(-86400))

    return NavigationStack {
      HStack {
        Text("History")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
        // clear history button
        Button(action: {
          showDeleteAlert = true
        }) {
          Text("Clear History")
            .foregroundColor(.accentColor)
            .background(Color(.black))
        }
        .alert(isPresented: $showDeleteAlert) {
          Alert(
            title: Text("Clear History"),
            message: Text("Are you sure you want to clear your history?"),
            primaryButton: .destructive(Text("Clear")) {
              store.emptyHistory()
            },
            secondaryButton: .cancel()
          )
        }
      }
      if store.history.count > 0 {

        List {
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
              .foregroundColor(.white).listRowBackground(Color.black)

            HistoryDayView(
              workouts: store.workoutsByDate[day]!,
              delete: delete
            ).listRowBackground(Color.black)

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
  var delete: (Workout) -> Void
  var body: some View {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "h:mm a"

    return
      ForEach(workouts) { workout in
        // only show time
        let time = dateFormatter.string(from: workout.startedAt)
        ZStack {
          NavigationLink(destination: CompletedWorkoutOverview(currentWorkout: .constant(workout)))
          {
            EmptyView()
          }
          HStack {
            HStack {
              Text("\(workout.exercises.count) exercises")
              Spacer()
              HStack {
                Text("\(time)")
                Text("\(workout.duration)")
              }
              Spacer()
              Image(systemName: "chevron.right").foregroundColor(.accentColor).aspectRatio(
                contentMode: .fit
              ).frame(width: 7)
            }
          }.padding().background(Color(.black)).foregroundColor(.white).cornerRadius(10)
        }.padding(.horizontal).overlay(
          RoundedRectangle(cornerRadius: 10).stroke(Color.accentColor, lineWidth: 2)
        )

      }.onDelete(perform: { indexSet in
        for index in indexSet {
          delete(workouts[index])
        }
      })

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
    return ContentView(selectedTab: 2, store: mock_store)
  }
}
