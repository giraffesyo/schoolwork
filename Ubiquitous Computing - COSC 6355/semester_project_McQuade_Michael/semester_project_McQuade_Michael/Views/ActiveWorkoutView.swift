import SwiftUI

// preset array of exercises for testing
let pushups = Exercise(
  name: "Pushups",
  description: "Pushups are a great exercise for your chest and arms.",
  image: Image("pushup"),
  type: .sets
)

let eliptical = Exercise(
  name: "Eliptical",
  description: "Eliptical is a great exercise for your legs and arms.",
  image: Image("eliptical"),
  type: .time
)

let exercises = [pushups, eliptical]

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
  var body: some View {
    VStack {
      Text("Exercises")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
        .frame(maxWidth: .infinity, alignment: .leading)
      List {
        ForEach(exercises) { exercise in
          ExerciseListRowView(exercise: exercise)
        }
      }
    }
  }
}

struct ExerciseListRowView: View {
  var exercise: Exercise
  var body: some View {
    HStack {
      exercise.image?
        .resizable()
        .frame(width: 50, height: 50)
        .clipShape(Circle())
      VStack(alignment: .leading) {
        HStack {
          Text(exercise.name)
            .font(.headline)
          Spacer()
          Text(exercise.type == .sets ? "Sets" : "Timed")
            .font(.subheadline)
        }
        Text(exercise.description)
          .font(.subheadline)
      }
    }
  }
}

struct ActiveWorkoutView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView(
      activeWorkout: true,
      currentWorkout: Workout(startedAt: Date())
    )
  }
}
