import SwiftUI

struct ActiveWorkoutView: View {
  @Binding var currentWorkout: Workout
  var body: some View {

    VStack {
      HStack {
        Text("Workout")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
        Button(action: {
          print("Button pressed")
        }) {
          Text("End Workout")
            .foregroundColor(.accentColor)
            .background(Color(.black))
        }
      }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
      // Live timer
      WorkoutTimerView(currentWorkout: $currentWorkout)
      // Exercise list
      // ExerciseListView(currentWorkout: $currentWorkout)
      Spacer()
    }
  }
}

struct ActiveWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      activeWorkout: true,
      currentWorkout: Workout(startedAt: Date())
    )
  }
}
