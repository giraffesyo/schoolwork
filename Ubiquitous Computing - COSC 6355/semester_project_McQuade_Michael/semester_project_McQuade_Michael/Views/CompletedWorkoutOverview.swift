import SwiftUI

struct CompletedWorkoutOverview: View {
  @Binding var currentWorkout: Workout
  var body: some View {

    return VStack {

      Text(currentWorkout.duration).font(.system(size: 60))
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding()
      Text("Exercises").font(.system(size: 24))
        .fontWeight(.bold)
        .foregroundColor(.white)
        .padding(.bottom)
        .padding(.horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
      currentWorkout.exercises.count == 0
        ? AnyView(
          Text("No exercises performed")
            .font(.system(size: 18))
            .fontWeight(.bold)
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)
        )
        : AnyView(
          List {
            ForEach(currentWorkout.exercises) { exercise in
              HStack {
                Text(exercise.metadata.name)
                if exercise.metadata.type == .bodyweight_sets {
                  Text("\(exercise.sets) sets")
                } else if exercise.metadata.type == .weighted_sets {
                  Text("\(exercise.sets) sets")
                  Text("\(exercise.weight) lbs")
                } else if exercise.metadata.type == .time {
                  Text("\(exercise.duration)")
                }
              }
            }
          })
      Spacer()
    }.navigationTitle("Workout Overview")
  }

}

/// This preview does not show the tab bar because we're only previewing the CompletedWorkoutOverview view,
/// but the tab bar will be present in the app.
struct CompletedWorkoutOverview_Previews: PreviewProvider {

  static let mock_store = Store()
  static var previews: some View {
    mock_store.emptyHistory()

    var workout = Workout(
      startedAt: Date().addingTimeInterval(-43200 * 2),
      endedAt: Date().addingTimeInterval(-43200 * 2 + 3600))
    workout.exercises.append(
      Exercise(
        metadata: PRELOADED_EXERCISES.curl, sets: 3, weight: 50,
        startedAt: Date().addingTimeInterval(-43200 * 2 + 1800),
        endedAt: Date().addingTimeInterval(-43200 * 2 + 3600))
    )
    workout.exercises.append(
      Exercise(
        metadata: PRELOADED_EXERCISES.eliptical,
        startedAt: Date().addingTimeInterval(-43200 * 2 + 1800),
        endedAt: Date().addingTimeInterval(-43200 * 2 + 3600))
    )
    mock_store.addWorkout(workout: workout)

    return ContentView(
      currentWorkout: nil,
      selectedTab: 2,
      store: mock_store
    )
  }
}
