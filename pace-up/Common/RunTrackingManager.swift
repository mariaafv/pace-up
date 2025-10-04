import Foundation
import CoreLocation

protocol RunTrackingDelegate: AnyObject {
  func didUpdate(metrics: RunMetrics)
  func didEncounterError(error: Error)
  func didChangeLocationPermission(authorized: Bool)
}

class RunTrackingManager: NSObject, CLLocationManagerDelegate {
  
  private let locationManager = CLLocationManager()
  private var timer: Timer?
  
  private var startTime: Date?
  private var totalDistance: CLLocationDistance = 0
  private var locations: [CLLocation] = []
  private var currentRunState: RunState = .ready
  
  weak var delegate: RunTrackingDelegate?
  
  override init() {
    super.init()
    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    locationManager.distanceFilter = 10
    locationManager.allowsBackgroundLocationUpdates = true
    locationManager.pausesLocationUpdatesAutomatically = false
  }
  
  func requestPermission() {
    let status = locationManager.authorizationStatus
    if status == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
    }
  }
  
  func start() {
    startTime = Date()
    totalDistance = 0
    locations.removeAll()
    currentRunState = .running
    
    locationManager.startUpdatingLocation()
    startTimer()
  }
  
  func pause() {
    currentRunState = .paused
    stopTimer()
  }
  
  func resume() {
    currentRunState = .running
    startTimer()
  }
  
  func stop() -> (time: TimeInterval, distance: CLLocationDistance, locations: [CLLocation]) {
    currentRunState = .finished
    locationManager.stopUpdatingLocation()
    stopTimer()
    
    let finalTime = Date().timeIntervalSince(startTime ?? Date())
    return (finalTime, totalDistance, locations)
  }
  
  private func startTimer() {
    timer?.invalidate()
    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
      self?.updateMetrics()
    }
  }
  
  private func stopTimer() {
    timer?.invalidate()
    timer = nil
  }
  
  private func updateMetrics() {
    guard let startTime = startTime, currentRunState == .running else { return }
    let duration = Date().timeIntervalSince(startTime)
    
    let currentPace = duration / totalDistance
    
    let metrics = RunMetrics(time: duration, distance: totalDistance, pace: currentPace)
    delegate?.didUpdate(metrics: metrics)
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations newLocations: [CLLocation]) {
    guard currentRunState == .running, let latestLocation = newLocations.last else { return }
    
    if latestLocation.horizontalAccuracy < 0 || latestLocation.horizontalAccuracy > 65 {
      return
    }
    
    if let lastLocation = locations.last {
      let distance = latestLocation.distance(from: lastLocation)
      if distance > 0 {
        totalDistance += distance
      }
    }
    
    locations.append(latestLocation)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print("Erro no GPS: \(error.localizedDescription)")
    delegate?.didEncounterError(error: error)
  }
  
  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      delegate?.didChangeLocationPermission(authorized: true)
    case .denied, .restricted:
      delegate?.didChangeLocationPermission(authorized: false)
    case .notDetermined:
      break
    @unknown default:
      delegate?.didChangeLocationPermission(authorized: false)
    }
  }
}
