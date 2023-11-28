import SwiftUI

struct CreateExerciseView: View {
  @EnvironmentObject var store: Store
  @State var showIconPicker = false
  @State var name = ""
  @State var description = ""
  @State var type = ExerciseType.bodyweight_sets
  var body: some View {
    ScrollView {
      // Image picker, using system image icon
      Image(systemName: "camera")
        .resizable()
        .frame(width: 100, height: 100)
        .onTapGesture {
          // open image picker
        }
      HStack {
        Text("Name")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .background(Color(.black))
        Spacer()
      }
      TextField(
        "Name", text: $name, prompt: Text("Enter a name...").foregroundColor(.gray)
      )
      .foregroundColor(.white)

      HStack {
        Text("Type")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .background(Color(.black))
        Spacer()
      }
      Picker(selection: $type, label: Text("Type")) {
        Text("Bodyweight Sets").tag(ExerciseType.bodyweight_sets)
        Text("Weighted Sets").tag(ExerciseType.weighted_sets)
        Text("Time").tag(ExerciseType.time)

      }.pickerStyle(SegmentedPickerStyle())
      // description box
      HStack {
        Text("Description")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .background(Color(.black))
        Spacer()
      }
      TextField(
        "Description", text: $description,
        prompt: Text("Enter a description...").foregroundColor(.gray)
      )
      Spacer()
    }
    .navigationTitle("Adding New Exercise")
    .toolbar {
      Button("Add") {
        // add exercise to store
        store.addExercise(
          exercise: ExerciseMetadata(
            name: name,
            description: description,
            customImage: false,
            image: "pushups",
            type: type
          )
        )
      }
    }
  }
}

struct CreateExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      currentWorkout: Workout(startedAt: Date())
    )
  }
}
