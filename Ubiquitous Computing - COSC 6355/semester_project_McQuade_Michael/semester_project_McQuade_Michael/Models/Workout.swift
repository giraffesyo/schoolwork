import SwiftUI

struct Workout: Identifiable {
  var id = UUID()
  var startedAt: Date
  var endedAt: Date?
}
