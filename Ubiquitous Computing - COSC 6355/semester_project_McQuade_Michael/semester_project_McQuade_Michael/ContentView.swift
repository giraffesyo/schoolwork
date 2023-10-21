import SwiftUI

struct ContentView: View {
  var body: some View {
    ZStack {

      TabView {
        WorkoutView()
          .tabItem {
            Image(systemName: "house")
            Text("Home")
          }
        WorkoutView()
          .tabItem {
            Image(systemName: "list.bullet")
            Text("Workouts")

          }
        WorkoutView()
          .tabItem {
            Image(systemName: "person")
            Text("Profile")
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
