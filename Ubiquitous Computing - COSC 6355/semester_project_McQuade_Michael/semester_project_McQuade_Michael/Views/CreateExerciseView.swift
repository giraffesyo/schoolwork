import PhotosUI
import SwiftUI

struct CreateExerciseView: View {
  @EnvironmentObject private var store: Store
  //  @State private var showImagePicker = false
  @State private var selectedPhoto: PhotosPickerItem?
  @Binding var navigationStack: NavigationPath
  @State private var image: Image?
  @State private var name = ""
  @State private var description = ""
  @State private var type = ExerciseType.bodyweight_sets  // initial value

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
        selectedPhoto == nil
          ? AnyView(
            Label("Select a photo", systemImage: "photo"))
          : AnyView(
            image?
              .resizable()
              .aspectRatio(contentMode: .fit)
              .frame(width: 100, height: 100)

          )
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
    .task(id: selectedPhoto) {
      image = try? await selectedPhoto?.loadTransferable(type: Image.self)
    }
    .navigationTitle("Adding New Exercise")
    .toolbar {
      Button("Add") {
        // if we have an image, save it to application sandbox
        if let image = image {
          guard let uiImage = image.getUIImage(newSize: CGSizeMake(100, 100)) else {
            return
          }
          store.saveImage(image: uiImage, name: name)
        }
        // add exercise to store
        store.addExercise(
          exercise: ExerciseMetadata(
            name: name,
            description: description,
            customImage: true,
            image: name,
            type: type
          )
        )
        // print out navigation stack
        print(navigationStack)
        // go back to previous screen
        navigationStack.removeLast()
      }
    }
  }
}

extension Image {
  @MainActor
  func getUIImage(newSize: CGSize) -> UIImage? {
    let image = resizable()
      .scaledToFill()
      .frame(width: newSize.width, height: newSize.height)
      .clipped()
    return ImageRenderer(content: image).uiImage
  }
}

struct CreateExerciseView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      currentWorkout: Workout(startedAt: Date())
    )
  }
}
