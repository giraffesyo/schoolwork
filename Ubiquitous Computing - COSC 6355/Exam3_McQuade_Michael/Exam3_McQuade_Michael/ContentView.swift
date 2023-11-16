import SwiftUI
import Vision

enum ImageFilter: String {
  case original = "Original"
  case blur = "Blur"
  case binarized = "Binarized"
}

struct ContentView: View {
  // we have 3 images sample1, sample2, and sample3 in an array
  var images: [String] = [
    "sample1",
    "sample2",
    "sample3",
  ]
  @State private var image: UIImage
  @State private var imageFilter = ImageFilter.original
  @State private var filterStrength = 0.0
  @State private var recognizedText = ""

  init() {
    // set the image to the first image in the array
    image = UIImage(named: images[0])!
  }

  func selectRandomImage() {
    // select a random image from the array
    let randomIndex = Int.random(in: 0..<images.count)
    // set the image
    setImage(index: randomIndex)
  }

  func setImage(index: Int) {
    image = UIImage(named: images[index])!
    // processImage()
  }

  func processImage() {
    // recognize the text
    recognizeText()

    // print the recognized text
    print(recognizedText)
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
    // process the image
    processImage()
  }
  // sets filter strength to whatever the slider is set to
  func setFilterStrength(value: Double) {
    filterStrength = value
  }

  func recognizeText() {
    // empty the recognized text
    recognizedText = ""
    // create a request handler
    let requestHandler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
    // create a request
    let request = VNRecognizeTextRequest { (request, error) in
      // get the results
      guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
      // loop through the results
      for observation in observations {
        // loop through the top candidates
        for candidate in observation.topCandidates(1) {
          // append to recognized text
          self.recognizedText += candidate.string
        }
      }
    }
    // set the recognition level
    request.recognitionLevel = .accurate
    // perform the request, catch any errors
    do {
      try requestHandler.perform([request])
    } catch {
      print(error)
    }
  }

  var body: some View {
    VStack {
      Text("TXT Recognition vs Image Filters")
        .padding()
      Picker(selection: $imageFilter, label: Text("Image Filter")) {
        Text(ImageFilter.original.rawValue).tag(ImageFilter.original)
        Text(ImageFilter.blur.rawValue).tag(ImageFilter.blur)
        Text(ImageFilter.binarized.rawValue).tag(ImageFilter.binarized)
      }.pickerStyle(SegmentedPickerStyle()).frame(width: 200).padding()
      Image(uiImage: image)
        .resizable()
        .scaledToFit()
        .frame(width: 300, height: 300)
        .onAppear(perform: processImage)
      HStack {
        Button(action: selectRandomImage) {
          Image(systemName: "photo")
            .font(.largeTitle)
        }
        // slider to change filter strength, disabled if original image
        Slider(value: $filterStrength, in: 0...3, step: 0.01)
          .disabled(imageFilter == .original)
      }
      // Multiline Text recognized from image
      Text(recognizedText)
        .multilineTextAlignment(.center)
        .padding()

      Spacer()
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
