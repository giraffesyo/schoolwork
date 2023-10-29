import SwiftUI

struct Days {
  static let Monday: String = "Mo"
  static let Tuesday: String = "Tu"
  static let Wednesday: String = "We"
  static let Thursday: String = "Th"
  static let Friday: String = "Fr"
  static let Saturday: String = "Sa"
  static let Sunday: String = "Su"
  static let all: [String] = [
    Days.Monday,
    Days.Tuesday,
    Days.Wednesday,
    Days.Thursday,
    Days.Friday,
    Days.Saturday,
    Days.Sunday,
  ]
}

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
      HStack {
        ForEach(Days.all, id: \.self) { day in
          DayView(day: day, exercised: false)
        }
      }
      Spacer()
    }
  }
}

struct DayView: View {
   var day = ""
   var exercised = false
  var body: some View {
    VStack {
      Circle()
        .frame(width: 10, height: 10)
        .foregroundColor(exercised ? .accentColor : .black)
      Text(day).foregroundColor(exercised ? .accentColor : .gray)
    }
  }
}

struct GoalsView_Previews: PreviewProvider {

  static var previews: some View {
    ContentView(selectedTab: 1)
  }
}
