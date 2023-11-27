import SwiftUI

struct ContentView: View {
  @StateObject var store: Store = Store()

  @State private var currentWorkout: Workout?
  @State private var selectedTab: Int = 0

  init(
    currentWorkout: Workout? = nil, selectedTab: Int = 0, store: Store? = nil
  ) {
    _currentWorkout = State(initialValue: currentWorkout)
    _selectedTab = State(initialValue: selectedTab)
    if let store = store {
      _store = StateObject(wrappedValue: store)
    }
  }
  func startWorkout() {
    currentWorkout = Workout(startedAt: Date())
  }
  func endWorkout() {
    currentWorkout!.endedAt = Date()
    store.addWorkout(workout: currentWorkout!)
    currentWorkout = nil
    selectedTab = 2  // switch to history tab
  }

  var body: some View {
    ZStack {
      Color(.black)
        .edgesIgnoringSafeArea(.all)

      TabView(selection: $selectedTab) {
        (currentWorkout != nil
          ? AnyView(
            ActiveWorkoutView(
              currentWorkout:
                Binding<Workout>(
                  get: { self.currentWorkout! }, set: { self.currentWorkout = $0 }),
              endWorkout: endWorkout
            ))
          : AnyView(StartWorkoutView(startWorkout: startWorkout)))
          .tabItem {
            Text("Workout")
            Image(systemName: "figure.walk")
          }.tag(0)
        GoalsView()
          .tabItem {
            Text("Goals")
            Image(systemName: "chart.pie")
          }.tag(1)
        HistoryView()
          .tabItem {
            Text("History")
            Image(systemName: "chart.bar")
          }.tag(2).padding(.vertical)  // this padding is to fix overlap of tab bar and list view in history
      }.toolbarBackground(Color.accentColor, for: .tabBar).preferredColorScheme(.dark)
        .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)

    }.environmentObject(store)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
