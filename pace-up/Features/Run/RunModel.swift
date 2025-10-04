import Foundation
import CoreLocation

struct Run: Codable {
  let id: Int?
  let user_id: String
  let name: String
  let duration_seconds: Int
  let distance_meters: Double
  let start_time: Date
  let created_at: Date?
  
  var formattedDuration: String {
    let hours = duration_seconds / 3600
    let minutes = (duration_seconds % 3600) / 60
    let seconds = (duration_seconds % 3600) % 60
    if hours > 0 {
      return String(format: "%d:%02d:%02d", hours, minutes, seconds)
    } else {
      return String(format: "%02d:%02d", minutes, seconds)
    }
  }
  
  var formattedDistanceKm: String {
    return String(format: "%.2f km", distance_meters / 1000)
  }
  
  var formattedPaceMinPerKm: String {
    guard distance_meters > 0 else { return "0'00\"" }
    let totalMinutes = Double(duration_seconds) / 60.0
    let totalKm = distance_meters / 1000.0
    let pace = totalMinutes / totalKm
    
    let paceMinutes = Int(pace)
    let paceSeconds = Int((pace - Double(paceMinutes)) * 60)
    
    return String(format: "%d'%02d\"", paceMinutes, paceSeconds)
  }
}

enum RunState {
  case ready, running, paused, finished
}

struct RunMetrics {
  let time: TimeInterval
  let distance: CLLocationDistance
  let pace: Double
  
  var formattedTime: String {
    let minutes = Int(time) / 60
    let seconds = Int(time) % 60
    return String(format: "%02d:%02d", minutes, seconds)
  }
  
  var formattedDistance: String {
    return String(format: "%.2f", distance / 1000)
  }
  
  var formattedPace: String {
    guard pace.isFinite && pace > 0 else { return "0'00\"" }
    let paceMinPerKm = pace * 1000 / 60
    let minutes = Int(paceMinPerKm)
    let seconds = Int((paceMinPerKm - Double(minutes)) * 60)
    return String(format: "%d'%02d\"", minutes, seconds)
  }
}
