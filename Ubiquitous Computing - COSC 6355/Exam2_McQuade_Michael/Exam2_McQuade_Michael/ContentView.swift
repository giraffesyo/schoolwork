//
//  ContentView.swift
//  Exam2_McQuade_Michael
//
//  Created by Michael McQuade on 10/19/23.
//

import MapKit
import SwiftUI

let CustomGreen = Color(red: 0, green: 0.365, blue: 0.467)

struct ContentView: View {
  @State private var findables = [Findable]()
  @State private var currentFilter = "Everyone"
  func fetchFindables() async {

    guard
      let url = URL(
        string:
          "https://m.cpl.uh.edu/courses/ubicomp/fall2022/webservice/people.json"
      )
    else {
      print("Invalid URL")
      return
    }
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data {
        do {
          let decoder = JSONDecoder()
          let f = try decoder.decode([Findable].self, from: data)
          findables = f.map { findable in
            return Findable(
              id: findable.id,
              distance: findable.distance,
              type: findable.type,
              name: findable.name,
              location: findable.location,
              lati: findable.lati,
              longi: findable.longi
            )
          }
        } catch {
          print("JSON Decode failed")
        }
      } else if let error = error {
        print(error.localizedDescription)
      }
    }
    task.resume()
    print(findables)
  }

  var body: some View {
    VStack {
      NavigationStack {
        // when you tap on vstack it will go to FilterView
        NavigationLink(destination: FilterView(currentFilter: $currentFilter)) {
          CurrentFilterView(currentFilter: $currentFilter)
        }
        Spacer()
        // List($findables) { findable in
        //   FindableRow(findable: findable)
        // }
        // for each loop over $findables, with if statement for current filter
        List {
          ForEach($findables) { findable in

            FindableRow(findable: findable, currentFilter: $currentFilter)

          }
        }
      }
    }.task {
      await fetchFindables()
    }

  }
}

struct CurrentFilterView: View {
  @Binding var currentFilter: String
  var onChangeFilterScreen = false

  @Environment(\.verticalSizeClass) var verticalSizeClass

  var body: some View {
    let isLandscape = verticalSizeClass == .compact
    VStack {
      Text(currentFilter)
        .font(.largeTitle)
        // color blue
        .foregroundColor(!onChangeFilterScreen ? .blue : .black)
        .fontWeight(.bold)
      Text("somewhere near me")
        .font(.largeTitle)
        .frame(maxWidth: isLandscape ? .infinity : 200).multilineTextAlignment(.center)
        .foregroundColor(CustomGreen)
        .fontWeight(.bold)
    }
  }
}

struct FilterTypes {
  static let everyone = "Everyone"
  static let friends = "Friends"
  static let closeFriends = "Close friends"
  static let relatives = "Relatives"
  static let colleagues = "Colleagues"
}

// View for changing the filter of the list
struct FilterView: View {
  @Environment(\.dismiss) private var dismiss

  @Binding var currentFilter: String
  func setFilter(filter: String) {
    currentFilter = filter
    dismiss()
  }
  var body: some View {
    VStack {
      CurrentFilterView(currentFilter: $currentFilter, onChangeFilterScreen: true)
      List {
        Text(FilterTypes.everyone).onTapGesture {
          setFilter(filter: FilterTypes.everyone)
        }
        Text(FilterTypes.friends).onTapGesture {
          setFilter(filter: FilterTypes.friends)
        }
        Text(FilterTypes.closeFriends).onTapGesture {
          setFilter(filter: FilterTypes.closeFriends)
        }
        Text(FilterTypes.relatives).onTapGesture {
          setFilter(filter: FilterTypes.relatives)
        }
        Text(FilterTypes.colleagues).onTapGesture {
          setFilter(filter: FilterTypes.colleagues)
        }
      }.foregroundColor(.blue).font(.system(size: CGFloat(35))).bold()
    }
  }
}

struct FindableRow: View {
  @Binding var findable: Findable
  @Binding var currentFilter: String
  var body: some View {
    if currentFilter == FilterTypes.everyone
      || currentFilter == findable.type
    {
      return AnyView(
        NavigationLink(destination: FindableDetail(findable: $findable)) {
          VStack(alignment: .leading) {
            HStack {
              Text(findable.name)
                .font(.system(size: CGFloat(25)))
                .fontWeight(.bold).lineLimit(1)
              Text("\(findable.distance) miles")
                .font(.system(size: CGFloat(15)))
                .fontWeight(.bold)
            }
          }
        })
    } else {
      return AnyView(EmptyView())
    }
  }
}

struct FindableDetail: View {
  @Binding var findable: Findable
  var body: some View {

    TabView {
      FindableInfo(findable: $findable)
        .tabItem {
          Image(systemName: "info.circle")
          Text("Details")
        }
      FindableMap(findable: $findable)
        .tabItem {
          Image(systemName: "map")
          Text("Map")
        }.edgesIgnoringSafeArea(.horizontal)
    }

  }
}

struct FindableInfo: View {
  @Binding var findable: Findable
  @Environment(\.verticalSizeClass) var verticalSizeClass
  var body: some View {
    let isLandscape = verticalSizeClass == .compact
    let layout =
      isLandscape ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

    layout {

      VStack {

        Text(findable.name)
          .padding().bold().foregroundColor(.blue)

        Text("Distance: \(findable.distance)")
        Text("At: \(findable.location)").multilineTextAlignment(.center).padding(.bottom)
        Text("You are: \(findable.type)")
      }.font(.system(size: CGFloat(45))).foregroundColor(CustomGreen)
    }
  }
}

struct FindableMap: View {
  @Binding var findable: Findable
  @Environment(\.verticalSizeClass) var verticalSizeClass

  var body: some View {
    let isLandscape = verticalSizeClass == .compact
    let layout =
      isLandscape ? AnyLayout(HStackLayout()) : AnyLayout(VStackLayout())

    layout {

      VStack {

        MapView(findable: $findable)
          .frame(width: .infinity, height: .infinity)
      }
    }
  }
}

struct MapView: UIViewRepresentable {
  @Binding var findable: Findable
  func updateUIView(_ view: MKMapView, context: Context) {
    let coordinate = CLLocationCoordinate2D(
      latitude: findable.lati, longitude: findable.longi)
    let span = MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)
    let region = MKCoordinateRegion(center: coordinate, span: span)
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = "\(findable.name) is here!"
    view.setRegion(region, animated: true)
    view.addAnnotation(annotation)
  }
  /**
     - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
     */
  func makeUIView(context: Context) -> MKMapView {
    MKMapView(frame: .zero)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
