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
    // Limpar todos os dados do usuário dos UserDefaults
    UserDefaults.standard.removeObject(forKey: "user_id")
    UserDefaults.standard.removeObject(forKey: "user_name")
    UserDefaults.standard.removeObject(forKey: "user_email")
    UserDefaults.standard.removeObject(forKey: "auth_token")
    
    // Resetar propriedades da instância
    userID = nil
    userName = nil
    
    // Fazer logout no Supabase se necessário
    Task {
      try? await SupabaseManager.shared.client.auth.signOut()
    }
    
    print("Logout realizado com sucesso")
  }
}

// MARK: - SessionManager Extension para Profile

extension SessionManager {
    
    // MARK: - User Profile Properties
    
    var userEmail: String? {
        return UserDefaults.standard.string(forKey: "user_email")
    }
    
    // MARK: - Profile Methods
    
    func updateUserName(_ name: String) {
        UserDefaults.standard.set(name, forKey: "user_name")
        self.userName = name
    }
    
    func updateUserEmail(_ email: String) {
        UserDefaults.standard.set(email, forKey: "user_email")
    }
    
    // Removido o método logout() duplicado
    
    func isUserLoggedIn() -> Bool {
        return userID != nil && !userID!.isEmpty
    }
    
    // MARK: - Additional Profile Methods
    
    func saveUserData(id: String, name: String?, email: String?) {
        UserDefaults.standard.set(id, forKey: "user_id")
        if let name = name {
            UserDefaults.standard.set(name, forKey: "user_name")
        }
        if let email = email {
            UserDefaults.standard.set(email, forKey: "user_email")
        }
        
        self.userID = id
        self.userName = name
    }
    
    func loadUserDataFromStorage() {
        userID = UserDefaults.standard.string(forKey: "user_id")
        userName = UserDefaults.standard.string(forKey: "user_name")
    }
}
