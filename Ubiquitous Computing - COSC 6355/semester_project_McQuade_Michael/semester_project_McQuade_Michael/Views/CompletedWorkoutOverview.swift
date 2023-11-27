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
              Text(exercise.metadata.name)
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

    let workout = Workout(
      startedAt: Date().addingTimeInterval(86400 * 2),
      endedAt: Date().addingTimeInterval(86400 * 2 + 3600))
    mock_store.addWorkout(workout: workout)

    return ContentView(
      currentWorkout: nil,
      selectedTab: 2,
      store: mock_store
    )
  }
}
