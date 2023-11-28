import SwiftUI

struct CurrentExerciseView: View {
  @Binding var exercise: Exercise
  @State var showWeightPicker = false
  @FocusState private var keyboardFocused

  var body: some View {
    VStack {
      Image(exercise.metadata.image)
        .resizable()
        .frame(width: 100, height: 100)
        .clipShape(Circle())
      Text(exercise.metadata.description)
        .font(.subheadline)
        .foregroundColor(.accentColor)
      Spacer()
      if exercise.metadata.type == .bodyweight_sets || exercise.metadata.type == .weighted_sets {

        HStack {
          if exercise.metadata.type == .weighted_sets {
            VStack {
              Text("Weight")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.accentColor)
              Button(action: {
                // open weight picker
                showWeightPicker = true

              }) {
                Text("\(exercise.weight)")
                  .font(.system(size: 40))
                  .fontWeight(.bold)
                  .foregroundColor(.white)
              }.alert("Enter weight", isPresented: $showWeightPicker) {
                TextField("Weight", value: $exercise.weight, format: .number).keyboardType(
                  .numberPad
                )
                .focused($keyboardFocused).onAppear {
                  DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    keyboardFocused = true
                  }
                }.foregroundColor(.white)
                Button("OK") {
                  showWeightPicker = false
                }
              }
            }
          }
          VStack {
            Text("Sets")
              .font(.title)
              .fontWeight(.bold)
              .foregroundColor(.accentColor)
            HStack {
              Button(action: {
                exercise.decrementSets()
              }) {
                Image(systemName: "minus.circle")
                  .font(.system(size: 40))
                  .foregroundColor(.accentColor)
              }
              Text("\(exercise.sets)")
                .font(.system(size: 40))
                .fontWeight(.bold)
                .foregroundColor(.white)
              Button(action: {
                exercise.incrementSets()
              }) {
                Image(systemName: "plus.circle")
                  .font(.system(size: 40))
                  .foregroundColor(.accentColor)
              }
            }
          }
        }
      } else if exercise.metadata.type == .time {
        Text("Exercise Time")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Text(exercise.startedAt ?? Date(), style: .timer)
          .font(.system(size: 60))
          .fontWeight(.bold)
          .foregroundColor(.white)
      }
      Spacer()
    }
  }
}
