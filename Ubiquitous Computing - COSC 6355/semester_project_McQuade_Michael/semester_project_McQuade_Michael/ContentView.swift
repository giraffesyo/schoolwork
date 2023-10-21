import SwiftUI

struct Workout: Identifiable {
  var id = UUID()
  var startedAt: Date
  var endedAt: Date?
}

struct ContentView: View {
  @State private var activeWorkout = false
  @State private var currentWorkout: Workout?
  func startWorkout() {
    activeWorkout = true
    currentWorkout = Workout(startedAt: Date())
  }

  var body: some View {
    ZStack {
      Color(.black)
        .edgesIgnoringSafeArea(.all)
      TabView {
        (activeWorkout
          ? AnyView(
            ActiveWorkoutView(
              currentWorkout:
                Binding<Workout>(get: { self.currentWorkout! }, set: { self.currentWorkout = $0 })
            ))
          : AnyView(StartWorkoutView(startWorkout: startWorkout)))
          .tabItem {
            Text("Workout")
            Image(systemName: "figure.walk")
          }
        TODOView()
          .tabItem {
            Text("Goals")
            Image(systemName: "chart.pie")
          }
        TODOView()
          .tabItem {
            Text("History")
            Image(systemName: "chart.bar")
          }
      }.toolbarBackground(Color.accentColor).preferredColorScheme(.dark)
    }
  }
}

struct TODOView: View {
  var body: some View {

    VStack {

    }
  }
}

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

struct StartWorkoutView: View {
  var startWorkout: () -> Void
  var body: some View {

    VStack {
      HStack {
        Text("Workout")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
      }.frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
      Spacer()
      Image(systemName: "figure.walk")
        .resizable()
        .frame(width: 100, height: 150)
        .foregroundColor(.accentColor)

      Button(action: {
        self.startWorkout()
      }) {
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
