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
  func finishRun() async
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
  private let worker: RunWorkerProtocol
  var currentRunState: RunState = .ready {
    didSet {
      onRunStateChange?(currentRunState)
    }
  }
  private var runStartTime: Date?
  private var latestMetrics: RunMetrics = RunMetrics(time: 0, distance: 0, pace: 0)
  
  init(navigationDelegate: RunNavigationDelegate?,
       runTracker: RunTrackingManager = RunTrackingManager(),
       worker: RunWorkerProtocol = RunWorker()) {
    self.navigationDelegate = navigationDelegate
    self.runTracker = runTracker
    self.worker = worker
    
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
  
  func finishRun() async {
    guard currentRunState == .running || currentRunState == .paused else { return }
    
    let (duration, distance, _) = runTracker.stop()
    currentRunState = .finished
    
    guard let userID = SessionManager.shared.userID, let startTime = runStartTime else { return }
    
    let newRun = Run(id: nil,
                     user_id: userID,
                     name: "Corrida \(Date())",
                     duration_seconds: Int(duration),
                     distance_meters: distance,
                     start_time: startTime,
                     created_at: nil)
    
    do {
      try await worker.save(run: newRun)
      await MainActor.run {
        // navigate to run summary
      }
    } catch {
      print("❌ ViewModel: Falha ao salvar a corrida. Erro: \(error.localizedDescription)")
    }
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
