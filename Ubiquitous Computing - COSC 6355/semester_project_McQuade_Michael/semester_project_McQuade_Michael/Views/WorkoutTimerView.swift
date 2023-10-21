import SwiftUI

struct WorkoutTimerView: View {
  @Binding var currentWorkout: Workout
  var body: some View {

    Text(currentWorkout.startedAt, style: .timer)
      .font(.system(size: 60))
      .fontWeight(.bold)
      .foregroundColor(.white)
      .padding()
  }

}
