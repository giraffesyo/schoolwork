import SwiftUI

struct ContentView: View {
  @State private var activeWorkout = false
  func startWorkout() {
    activeWorkout = true
  }

  var body: some View {
    ZStack {
      Color(.black)
        .edgesIgnoringSafeArea(.all)
      TabView {
        (activeWorkout
          ? AnyView(ActiveWorkoutView())
         : AnyView(StartWorkoutView(startWorkout: startWorkout)))
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

    VStack {
      Text("Workout")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
        .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
      Spacer()
      Image(systemName: "figure.walk")
        .resizable()
        .frame(width: 100, height: 150)
        .foregroundColor(.accentColor)

      Button(action: {
        print("Button pressed")
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

struct ActiveWorkoutView: View {
  var body: some View {

    VStack {
      Text("Workout")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
        .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
      Spacer()

      Spacer()
    }
  }
}

struct StartWorkoutView: View {
    var startWorkout: () -> Void
    var body: some View {
      
    VStack {
      Text("Workout")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.accentColor)
        .frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal)
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
