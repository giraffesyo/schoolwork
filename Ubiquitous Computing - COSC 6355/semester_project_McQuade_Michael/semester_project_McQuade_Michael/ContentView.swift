import SwiftUI

struct ContentView: View {
  @State private var activeWorkout: Bool
  @State private var currentWorkout: Workout?
  init(activeWorkout: Bool = false, currentWorkout: Workout? = nil) {
    _activeWorkout = State(initialValue: activeWorkout)
    _currentWorkout = State(initialValue: currentWorkout)
  }
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

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
