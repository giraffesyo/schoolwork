import Combine
import WatchConnectivity

class SessionDelegator: NSObject, WCSessionDelegate {
  let words: PassthroughSubject<[String], Never>

  init(words: PassthroughSubject<[String], Never>) {
    self.words = words
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
      if let words = message["words"] as? [String] {
        self.words.send(words)
      } else {
        print("There was an error")
      }
    }
  }

  // iOS Protocol comformance
  #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
      print("\(#function): activationState = \(session.activationState.rawValue)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
      session.activate()
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
      print("\(#function): activationState = \(session.activationState.rawValue)")
    }
  #endif
}

class Words: ObservableObject {
  var wcsession: WCSession
  let delegate: WCSessionDelegate
  let subject = PassthroughSubject<[String], Never>()

  @Published private(set) var value: [String] = []

  func send(_ words: [String]) {
    value = words
    let message = ["words": words]
    wcsession.sendMessage(message, replyHandler: nil, errorHandler: nil)
  }

  init(session: WCSession = .default) {
    self.delegate = SessionDelegator(words: subject)
    self.wcsession = session
    self.wcsession.delegate = self.delegate
    self.wcsession.activate()

    subject
      .receive(on: DispatchQueue.main)
      .assign(to: &$value)
  }

}
