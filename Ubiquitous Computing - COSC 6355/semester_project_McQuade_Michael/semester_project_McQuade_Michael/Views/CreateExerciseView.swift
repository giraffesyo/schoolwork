import PhotosUI
import SwiftUI

struct CreateExerciseView: View {
  @EnvironmentObject private var store: Store
  //  @State private var showImagePicker = false
  @State private var selectedPhoto: PhotosPickerItem?

  @State private var image: UIImage?
  @State private var name = ""
  @State private var description = ""
  @State private var type = ExerciseType.bodyweight_sets

  var body: some View {
    ScrollView {
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
      // image picker
      HStack {
        Text("Image")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.white)
          .background(Color(.black))
        Spacer()
      }
      PhotosPicker(selection: $selectedPhoto, matching: .images) {
        Label("Select a photo", systemImage: "photo")
      }
      .tint(.black)
      .controlSize(.large)
      .buttonStyle(.borderedProminent)

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
