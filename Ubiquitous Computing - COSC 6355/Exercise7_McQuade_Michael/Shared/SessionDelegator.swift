import Combine
import WatchConnectivity

class SessionDelegator: NSObject, WCSessionDelegate {
  let bpmSubject: PassthroughSubject<Double, Never>

  init(bpmSubject: PassthroughSubject<Double, Never>) {
    self.bpmSubject = bpmSubject
    super.init()
  }

  func session(
    _ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState,
    error: Error?
  ) {
    // Protocol comformance only
    // Not needed
  }

  func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
    DispatchQueue.main.async {
      if let bpm = message["bpm"] as? Double {
        self.bpmSubject.send(bpm)
      } else {
        print("There was an error")
      }
    }
  }

  // iOS Protocol comformance
  // Not needed for this demo otherwise
  #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
      print("\(#function): activationState = \(session.activationState.rawValue)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
      // Activate the new session after having switched to a new watch.
      session.activate()
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
      print("\(#function): activationState = \(session.activationState.rawValue)")
    }
  #endif
}

class BPM: ObservableObject {
  var wcsession: WCSession
  let delegate: WCSessionDelegate
  let subject = PassthroughSubject<Double, Never>()

  @Published private(set) var value: Double = 0.0

  func send(_ bpm: Double) {
    value = bpm
    let message = ["bpm": bpm]
    wcsession.sendMessage(message, replyHandler: nil, errorHandler: nil)
  }

  init(session: WCSession = .default) {
    self.delegate = SessionDelegator(bpmSubject: subject)
    self.wcsession = session
    self.wcsession.delegate = self.delegate
    self.wcsession.activate()

    subject
      .receive(on: DispatchQueue.main)
      .assign(to: &$value)
  }

}
