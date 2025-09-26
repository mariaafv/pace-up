import Foundation

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
}

struct ProfileInfo: Decodable {
  let id: String?
  let workout_plan: WorkoutPlan?
  let planGenerationError: String?
  let rawAIResponse: String?
}
