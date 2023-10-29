import SwiftUI

struct GoalsView: View {
  var body: some View {

    VStack {
      HStack {
        Text("Goals")
          .font(.title)
          .fontWeight(.bold)
          .foregroundColor(.accentColor)
        Spacer()
      }
      Spacer()
    }
  }
}

struct GoalsView_Previews: PreviewProvider {

  static var previews: some View {
    ContentView(selectedTab: 1)
  }
}
