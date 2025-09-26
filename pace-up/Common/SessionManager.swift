import Foundation

final class SessionManager {
  static let shared = SessionManager()
  
  var userID: String?
  var userName: String?
  
  private init() {}
  
  var isLoggedIn: Bool {
    return userID != nil
  }
  
  func logout() {
    userID = nil
    userName = nil
  }
}
