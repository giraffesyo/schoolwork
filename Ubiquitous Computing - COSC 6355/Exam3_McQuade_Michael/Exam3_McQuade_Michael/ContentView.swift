import SwiftUI

enum ImageFilter: String {
  case original = "Original"
  case blur = "Blur"
  case binarized = "Binarized"
}

struct ContentView: View {
  // we have 3 images sample1, sample2, and sample3 in an array
  var images: [UIImage] = [
    UIImage(named: "sample1")!, UIImage(named: "sample2")!, UIImage(named: "sample3")!,
  ]
  @State private var imageIndex = 0
  @State private var imageFilter = ImageFilter.original
  @State private var filterStrength = 0.0

  func selectRandomImage() {
    // select a random image from the array
    imageIndex = Int.random(in: 0..<images.count)
  }

  func changeImageFilter() {
    // change the image filter
    switch imageFilter {
    case .original:
      imageFilter = .blur
      filterStrength = 0
    case .blur:
      imageFilter = .binarized
      filterStrength = 0.2
    case .binarized:
      imageFilter = .original
      filterStrength = 0.2
    }
  }
  // sets filter strength to whatever the slider is set to
  func setFilterStrength(value: Double) {
    filterStrength = value
  }

  var body: some View {
    VStack {
      Text("TXT Recognition vs Image Filters")
      Picker(selection: $imageFilter, label: Text("Image Filter")) {
        Text(ImageFilter.original.rawValue).tag(ImageFilter.original)
        Text(ImageFilter.blur.rawValue).tag(ImageFilter.blur)
        Text(ImageFilter.binarized.rawValue).tag(ImageFilter.binarized)
      }.pickerStyle(SegmentedPickerStyle())
      Image(uiImage: images[imageIndex])
        .resizable()
        .scaledToFit()
        .frame(width: 300, height: 300)
      HStack {
        Button(action: selectRandomImage) {
          Image(systemName: "photo")
            .font(.largeTitle)
        }
        // slider to change filter strength
        Slider(value: $filterStrength, in: 0...3, step: 0.01)
      }
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
