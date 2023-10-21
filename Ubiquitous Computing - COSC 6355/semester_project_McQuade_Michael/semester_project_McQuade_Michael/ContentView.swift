import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {
      TabView {
        WorkoutView()
          .tabItem {
            Text("Workout")
            Image(systemName: "figure.walk")
          }
        WorkoutView()
          .tabItem {
            Text("Goals")
            Image(systemName: "chart.pie")
          }
        WorkoutView()
          .tabItem {
            Text("History")
            Image(systemName: "chart.bar")
          }
      }.toolbarBackground(Color.accentColor).preferredColorScheme(.dark)
    }
  }
}

struct WorkoutView: View {
  var body: some View {
    ZStack {
      Color(.black)
        .edgesIgnoringSafeArea(.all)

      VStack {
        Text("Workouts")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Image(systemName: "globe")
          .imageScale(.large)
          .foregroundColor(.accentColor)
        Text("Hello, world!")
      }
    }
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
