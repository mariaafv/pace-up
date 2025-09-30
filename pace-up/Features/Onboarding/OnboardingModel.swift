import Foundation

struct ProfileUpdateDTO: Encodable {
  let weight: Float
  let height: Int
  let experience: String
  let goal: String
  let run_days: [String]
}

// No mesmo arquivo de Modelos
struct ProfileData: Decodable {
    let weight: Float?
    let height: Int?
    let experience: String?
    let goal: String?
    let run_days: [String]?
    let workout_plan: WorkoutPlan?
    let planGenerationError: String?
}
