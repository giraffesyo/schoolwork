import SwiftUI

struct StartWorkoutView: View {
  var startWorkout: () -> Void
  var body: some View {

    VStack {
      HStack {
        Text("Workout")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
      }.frame(maxWidth: .infinity, alignment: .leading)
      Spacer()
      Image(systemName: "figure.walk")
        .resizable()
        .frame(width: 100, height: 150)
        .foregroundColor(.accentColor)

      Button(action: startWorkout) {
        Text("Start Workout")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
          .padding()
          .background(Color(.black))
          .cornerRadius(40)
          .padding(10)
          .overlay(
            RoundedRectangle(cornerRadius: 40)
              .stroke(Color.accentColor, lineWidth: 5)
          )
      }.padding()
      Spacer()
    }
  }
}
