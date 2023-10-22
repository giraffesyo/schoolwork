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
    VStack {
      HStack {
        Text("Exercises")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
        currentWorkout.currentExercise != nil
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
          }) : AnyView(CurrentExerciseView(exercise: currentWorkout.currentExercise!))
    }
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
  var exercise: Exercise
  var body: some View {
    VStack {
      exercise.metadata.image?
        .resizable()
        .frame(width: 100, height: 100)
        .clipShape(Circle())
      Text(exercise.metadata.name)
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
      Text(exercise.metadata.description)
        .font(.subheadline)
        .foregroundColor(.accentColor)
      Spacer()
      if exercise.metadata.type == .bodyweight_sets {
        // -, sets count, +
        Text("Sets")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        HStack {
          Button(action: {}) {
            Image(systemName: "minus.circle")
              .font(.system(size: 60))
              .foregroundColor(.accentColor)
          }
          Text("\(exercise.sets ?? 0)")
            .font(.system(size: 60))
            .fontWeight(.bold)
            .foregroundColor(.white)
          Button(action: {}) {
            Image(systemName: "plus.circle")
              .font(.system(size: 60))
              .foregroundColor(.accentColor)
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
      } else if exercise.metadata.type == .weighted_sets {
        Text("Weighted Sets")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        HStack {
          Button(action: {}) {
            Image(systemName: "minus.circle")
              .font(.system(size: 60))
              .foregroundColor(.accentColor)
          }
          Text("\(exercise.sets ?? 0)")
            .font(.system(size: 60))
            .fontWeight(.bold)
            .foregroundColor(.white)
          Button(action: {}) {
            Image(systemName: "plus.circle")
              .font(.system(size: 60))
              .foregroundColor(.accentColor)
          }
        }
      }
      Spacer()
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
