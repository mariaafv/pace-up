import Foundation

struct TodayWorkout {
  let day: String?
  let weekNumber: Int
  let workoutType: String
  let description: String
  let durationMinutes: Int
  let targetDistance: Double?
  let completed: Bool
}

struct WorkoutPlan: Codable {
  let week1: [WorkoutDay]?
  let week2: [WorkoutDay]?
  let week3: [WorkoutDay]?
  let week4: [WorkoutDay]?
}

struct WorkoutDay: Codable {
  let day: String?
  let type: String?
  let duration_minutes: Int?
  let description: String?
  
  func toTodayWorkout(weekNumber: Int) -> TodayWorkout {
    return TodayWorkout(
      day: self.day, weekNumber: weekNumber,
      workoutType: self.type ?? "descanso",
      description: self.description ?? "Recuperação é parte do treino!",
      durationMinutes: self.duration_minutes ?? 0,
      targetDistance: nil,
      completed: false
    )
  }
}

struct ProfileInfo: Decodable {
  let id: String?
  let workout_plan: WorkoutPlan?
  let planGenerationError: String?
  let rawAIResponse: String?
}
