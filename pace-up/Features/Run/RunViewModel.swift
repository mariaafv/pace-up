import Foundation
import CoreLocation
import FirebaseAuth

protocol RunViewModelProtocol: AnyObject {
  var onRunStateChange: ((RunState) -> Void)? { get set }
  var onMetricsUpdate: ((RunMetrics) -> Void)? { get set }
  var onLocationPermissionDenied: (() -> Void)? { get set }
  var currentRunState: RunState { get set }
  
  func requestLocationPermission()
  func startRun()
  func pauseRun()
  func resumeRun()
  func finishRun() -> Run?
}

protocol RunNavigationDelegate: AnyObject {
  func navigateToRunSummary(run: Run)
}

class RunViewModel: RunViewModelProtocol {
  var onRunStateChange: ((RunState) -> Void)?
  var onMetricsUpdate: ((RunMetrics) -> Void)?
  var onLocationPermissionDenied: (() -> Void)?
  
  private weak var navigationDelegate: RunNavigationDelegate?
  private let runTracker: RunTrackingManager
  var currentRunState: RunState = .ready {
    didSet {
      onRunStateChange?(currentRunState)
    }
  }
  private var runStartTime: Date?
  private var latestMetrics: RunMetrics = RunMetrics(time: 0, distance: 0, pace: 0)
  
  init(navigationDelegate: RunNavigationDelegate?, runTracker: RunTrackingManager = RunTrackingManager()) {
    self.navigationDelegate = navigationDelegate
    self.runTracker = runTracker
    self.runTracker.delegate = self
  }
    
  func requestLocationPermission() {
    print("✅ DEBUG: ViewModel está chamando o rastreador...")
    runTracker.requestPermission()
  }

  func startRun() {
    guard currentRunState == .ready || currentRunState == .paused else { return }
    
    if currentRunState == .ready {
      runStartTime = Date()
      runTracker.start()
    } else if currentRunState == .paused {
      runTracker.resume()
    }
    currentRunState = .running
  }
  
  func pauseRun() {
    guard currentRunState == .running else { return }
    runTracker.pause()
    currentRunState = .paused
  }
  
  func resumeRun() {
    guard currentRunState == .paused else { return }
    runTracker.resume()
    currentRunState = .running
  }
  
  func finishRun() -> Run? {
    guard currentRunState == .running || currentRunState == .paused else { return nil }
    
    let (duration, distance, _) = runTracker.stop()
    currentRunState = .finished
    
    guard let userID = SessionManager.shared.userID, let startTime = runStartTime else { return nil }
    
    let newRun = Run(id: nil,
                     userId: userID,
                     name: "Corrida \(Date())",
                     durationSeconds: Int(duration),
                     distanceMeters: distance,
                     startTime: startTime,
                     createdAt: nil)
    
    return newRun
  }
}

extension RunViewModel: RunTrackingDelegate {
  func didUpdate(metrics: RunMetrics) {
    self.latestMetrics = metrics
    onMetricsUpdate?(metrics)
  }
  
  func didEncounterError(error: Error) {
    print("ViewModel recebeu erro do RunTrackingManager: \(error.localizedDescription)")
    // TODO: Notificar a UI
  }
  
  func didChangeLocationPermission(authorized: Bool) {
    if !authorized {
      onLocationPermissionDenied?()
    }
  }
}
