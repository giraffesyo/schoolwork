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
      Text(currentWorkout.startedAt, style: .timer)
        .font(.system(size: 60))
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
        .padding()
      Spacer()
    }
  }
}
