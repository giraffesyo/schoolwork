import SwiftUI

struct ActiveWorkoutView: View {
  @Binding var currentWorkout: Workout
  var endWorkout: () -> Void
  var body: some View {

    VStack {
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
      ExerciseListView(currentWorkout: $currentWorkout)
      Spacer()
    }
  }
}

struct ExerciseListView: View {
  @Binding var currentWorkout: Workout
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
          ? Button(action: {
            currentWorkout.endExercise()
          }) {
            Text("End Exercise")
              .foregroundColor(.accentColor)
              .background(Color(.black))
          } : nil
      }.frame(maxWidth: .infinity, alignment: .leading)
      currentWorkout.currentExercise == nil
        ? AnyView(
          List {
            ForEach(PRELOADED_EXERCISES.all) { metadata in
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

  struct ExerciseListRowView: View {
    var metadata: ExerciseMetadata
    var handleExerciseTap: (ExerciseMetadata) -> Void
    var body: some View {
      HStack {
        metadata.image?
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

  struct CurrentExerciseView: View {
    @Binding var exercise: Exercise
    @State var showWeightPicker = false
    @FocusState private var keyboardFocused
    var body: some View {
      VStack {
        exercise.metadata.image?
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
                  Text("\(exercise.weight ?? 0)")
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
                  }.foregroundColor(.black)
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
                Button(action: {}) {
                  Image(systemName: "minus.circle")
                    .font(.system(size: 40))
                    .foregroundColor(.accentColor)
                }
                Text("\(exercise.sets ?? 0)")
                  .font(.system(size: 40))
                  .fontWeight(.bold)
                  .foregroundColor(.white)
                Button(action: {}) {
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
}

struct ActiveWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      currentWorkout: Workout(startedAt: Date())
    )
  }
}
