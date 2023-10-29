//
//  ContentView.swift
//  Exercise7_McQuade_Michael Watch App
//
//  Created by Michael McQuade on 10/28/23.
//

import HealthKit
import SwiftUI

import Combine
import WatchConnectivity




struct ContentView: View {

  
  @State var healthStore = HKHealthStore()
  @State var simulation = false
  @State var session: HKWorkoutSession!
  @State var builder: HKLiveWorkoutBuilder!
    
    @StateObject var bpm = BPM()

    
    

  func authorizeHealthKit() {
    let healthKitTypes: Set = [
      HKObjectType.quantityType(forIdentifier: .heartRate)!
    ]
    healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { _, _ in
      // Handle error
    }
  }

  private func startHeartRateQuery(quantityTypeIdentifier: HKQuantityTypeIdentifier) {
    let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()])

    let updateHandler:
      (HKAnchoredObjectQuery, [HKSample]?, [HKDeletedObject]?, HKQueryAnchor?, Error?) -> Void = {
        query, samples, deletedObjects, queryAnchor, error in

        guard let samples = samples as? [HKQuantitySample] else {
          return
        }

        self.process(samples, type: quantityTypeIdentifier)
      }
    let query = HKAnchoredObjectQuery(
      type: HKObjectType.quantityType(forIdentifier: quantityTypeIdentifier)!,
      predicate: devicePredicate,
      anchor: nil,
      limit: HKObjectQueryNoLimit,
      resultsHandler: updateHandler
    )
    query.updateHandler = updateHandler
    healthStore.execute(query)
  }

  private func createWorkoutEmulation() {
    let configuration = HKWorkoutConfiguration()
    configuration.activityType = .running
    configuration.locationType = .outdoor

    let healthStore = HKHealthStore()
    do {
      session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
      builder = session.associatedWorkoutBuilder()
    } catch {
      // Handle failure here.
    }

    session.startActivity(with: Date())
    builder.beginCollection(withStart: Date()) { (success, error) in
      // The workout has started!
    }
    simulation = true
  }

  private func stopWorkoutEmulation() {

    builder.endCollection(withEnd: Date()) { (success, error) in
      // The workout has ended.
    }
    session.stopActivity(with: Date())
    session.end()
      
      bpm.send(0.0)
    simulation = false
  }

  private func process(_ samples: [HKQuantitySample], type: HKQuantityTypeIdentifier) {
    var lastHeartRate = 0.0
    for sample in samples {
      if type == .heartRate {
        lastHeartRate = sample.quantity.doubleValue(for: HKUnit(from: "count/min"))
      }
      bpm.send(lastHeartRate)
    }
  }

  func start() {
    authorizeHealthKit()

    startHeartRateQuery(quantityTypeIdentifier: .heartRate)
  }

  var body: some View {
    VStack {
      // Single button w/ heart emoji
      Button(
        action: {
          if simulation {
            stopWorkoutEmulation()
          } else {
            createWorkoutEmulation()
          }
        },
        label: {
          Text("❤️")
        }
      ).font(.system(size: 50))
      HStack {
          Text("\(bpm.value, specifier: "%.0f")").font(.system(size: 70))
        VStack {
          Text("BPM").foregroundColor(.red).font(.system(size: 28)).font(.headline).bold()

          Spacer()
        }.frame(width: .infinity)
        Spacer()
      }
    }.onAppear(perform: start)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
