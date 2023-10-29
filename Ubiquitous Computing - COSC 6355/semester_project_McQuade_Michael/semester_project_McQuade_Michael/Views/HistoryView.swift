import SwiftUI

struct HistoryView: View {
  @EnvironmentObject var store: Store

  var body: some View {

    VStack {
      HStack {
        Text("History")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
      }
      if store.history.count > 0 {
        List {
          ForEach(store.history) { workout in
            NavigationLink(destination: TODOView()) {
              HStack {
                Text("\(workout.startedAt)")
                Spacer()
                Text("\(workout.exercises.count) exercises")
              }
            }
          }
        }
      } else {
        NoHistoryView()
      }
    }
  }
}

struct NoHistoryView: View {
  var body: some View {
    VStack {
      Spacer()
      Text("No history yet")
        .font(.title)
        .fontWeight(.bold)
        .foregroundColor(.white)

      Spacer()
    }
  }
}

struct HistoryView_Previews: PreviewProvider {

  static var previews: some View {
    ContentView(selectedTab: 2)
  }
}
