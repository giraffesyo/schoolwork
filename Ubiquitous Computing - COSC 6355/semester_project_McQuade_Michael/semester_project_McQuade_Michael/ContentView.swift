import SwiftUI

struct ContentView: View {
  @StateObject var store: Store = Store()

  @State private var currentWorkout: Workout?
  @State private var selectedTab: Int = 0
  @State private var presentingWorkout: Workout?

  init(
    currentWorkout: Workout? = nil, selectedTab: Int = 0, store: Store? = nil,
    presentingWorkout: Workout? = nil
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
    store.addWorkout(workout: currentWorkout!)
    store.presentingWorkout = currentWorkout
    currentWorkout = nil
  }

  var body: some View {
    ZStack {
      Color(.black)
        .edgesIgnoringSafeArea(.all)
      NavigationStack {
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
        NavigationLink(

          destination: CompletedWorkoutOverview(
            currentWorkout: Binding<Workout>(
              get: {
                if let workout = store.presentingWorkout {
                  return workout
                } else {
                  return Workout(startedAt: Date())
                }

              }, set: { store.presentingWorkout = $0 })
          ),
          isActive: Binding<Bool>(
            get: { store.presentingWorkout != nil }, set: { _ in store.presentingWorkout = nil })
        ) {
          EmptyView()
        }.hidden()
      }
    }.environmentObject(store)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
