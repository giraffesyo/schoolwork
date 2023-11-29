import SwiftUI

struct ActiveWorkoutView: View {
  @Binding var currentWorkout: Workout
  @State private var navigationStack = NavigationPath()
  var endWorkout: () -> Void
  var body: some View {

    NavigationStack(path: $navigationStack) {
      HStack {
        Text("Workout")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
        Button(action: endWorkout) {
          Text("End Workout")
            .foregroundColor(.accentColor)
            .background(Color(.black))
        }
      }
      // Live timer
      WorkoutTimerView(currentWorkout: $currentWorkout)
      // Exercise list
      ExerciseListView(currentWorkout: $currentWorkout, navigationStack: $navigationStack)
        .navigationDestination(for: String.self) { destination in
          CreateExerciseView(
            navigationStack: $navigationStack
          )
        }
      Spacer()
    }
  }
}

struct ExerciseListView: View {
  @EnvironmentObject var store: Store
  @Binding var currentWorkout: Workout
  @Binding var navigationStack: NavigationPath
  func handleExerciseTap(exercise: ExerciseMetadata) {
    currentWorkout.currentExercise = Exercise(metadata: exercise)
  }
  var body: some View {
    let currentlyExercising = currentWorkout.currentExercise != nil
    VStack {
      HStack {
        Text(
          currentlyExercising
            ? currentWorkout.currentExercise!.metadata.name
            : "Exercises"
        )
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
        Spacer()
        currentlyExercising
          ? AnyView(
            Button(action: {
              currentWorkout.endExercise()
            }) {
              Text("End Exercise")
                .foregroundColor(.accentColor)
                .background(Color(.black))
            })
          :  // we show Add Exercise button if we're not currently exercising
          AnyView(
            Button(action: {
              navigationStack.append("CreateExerciseView")
            }) {
              Text("Add Exercise")
                .foregroundColor(.accentColor)
                .background(Color(.black))
            }
          )
      }.frame(maxWidth: .infinity, alignment: .leading)
      currentWorkout.currentExercise == nil
        ? AnyView(
          List {
            ForEach(store.exercises) { metadata in
              ExerciseListRowView(metadata: metadata, handleExerciseTap: handleExerciseTap)
            }
          })
        : AnyView(
          CurrentExerciseView(
            exercise:
              Binding<Exercise>(
                get: { self.currentWorkout.currentExercise! },
                set: { self.currentWorkout.currentExercise = $0 })
          ))
    }

  }
}

struct ExerciseListRowView: View {
  var metadata: ExerciseMetadata
  var handleExerciseTap: (ExerciseMetadata) -> Void
  var body: some View {
    HStack {
      Image(metadata.image)
        .resizable()
        .frame(width: 50, height: 50)
        .clipShape(Circle())
      VStack(alignment: .leading) {
        HStack {
          Text(metadata.name)
            .font(.headline)
          Spacer()
          Text(metadata.type.rawValue)
            .font(.subheadline)
        }
        Text(metadata.description)
          .font(.subheadline)
      }
    }.onTapGesture {
      handleExerciseTap(metadata)
    }
  }
}

struct ActiveWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      currentWorkout: Workout(startedAt: Date())
    )
  }
}
