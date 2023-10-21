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
          // align left
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
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
