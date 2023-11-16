import SwiftUI

enum ImageFilter: String {
  case original = "Original"
  case blur = "Blur"
  case binarized = "Binarized"
}

struct ContentView: View {
  @State private var imageFilter = ImageFilter.original
  var body: some View {
    VStack {
      Text("TXT Recognition vs Image Filters")
      Picker(selection: $imageFilter, label: Text("Image Filter")) {
        Text(ImageFilter.original.rawValue).tag(ImageFilter.original)
        Text(ImageFilter.blur.rawValue).tag(ImageFilter.blur)
        Text(ImageFilter.binarized.rawValue).tag(ImageFilter.binarized)
      }.pickerStyle(SegmentedPickerStyle())
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
