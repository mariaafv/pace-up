import Foundation

struct ProfileData: Encodable {
  let weight: Float
  let height: Int
  let experience: String
  let goal: String
  let run_days: [String]
}
