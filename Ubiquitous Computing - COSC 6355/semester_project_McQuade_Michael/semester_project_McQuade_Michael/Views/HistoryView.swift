import SwiftUI

struct HistoryView: View {
  var body: some View {

    VStack {
      HStack {
        Text("History")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
      }
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
