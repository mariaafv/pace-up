import Foundation

protocol OnboardingWorkerProtocol: AnyObject {
  func saveProfileAndGeneratePlan(token: String, userId: String, profileData: ProfileData) async throws
}

class OnboardingWorker: OnboardingWorkerProtocol {
  func saveProfileAndGeneratePlan(token: String, userId: String, profileData: ProfileData) async throws {
    guard let url = URL(string: "https://pace-up-backend.vercel.app/api/generatePlan") else {
      throw URLError(.badURL)
    }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let requestBody: [String: Any] = [
      "userId": userId,
      "profileData": try profileData.toDictionary()
    ]
    
    request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
    
    let (_, response) = try await URLSession.shared.data(for: request)
    
    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
      let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
      throw NSError(domain: "NetworkError", code: statusCode, userInfo: [NSLocalizedDescriptionKey: "Erro na resposta do servidor Vercel."])
    }
    
    print("✅ Dados enviados com sucesso para a Vercel!")
  }
}

extension Encodable {
  func toDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
}
