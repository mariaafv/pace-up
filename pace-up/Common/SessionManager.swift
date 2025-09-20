import Foundation

final class SessionManager {
  static let shared = SessionManager()
  
  var userID: String?
  
  private init() {}
  
  var isLoggedIn: Bool {
    return userID != nil
  }
  
  func logout() {
    userID = nil
  }
}
