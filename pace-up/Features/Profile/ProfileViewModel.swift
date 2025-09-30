import Foundation
import FirebaseAuth

// MARK: - Data Models (Mantenha estes no mesmo arquivo ou em um arquivo de Modelo separado)

struct UserProfile {
    let name: String
    let email: String
    let level: String
    let weight: String?
    let height: String?
    let goal: String?
    let daysPerWeek: String?
    let totalDistance: String
    let totalRuns: String
}

enum ProfileState {
    case loading
    case loaded(profile: UserProfile)
    case error(Error)
}

// MARK: - Protocols

protocol ProfileViewModelProtocol: AnyObject {
    var onProfileStateChange: ((ProfileState) -> Void)? { get set }
    
    func fetchProfile()
    func didTapEditProfile()
    func performLogout() // Adicionamos para o ViewController chamar
  func refreshProfile()
}

protocol ProfileViewModelNavigationDelegate: AnyObject {
    func navigateToEditProfile()
    func navigateToWelcome() // Para o logout
}

// MARK: - ViewModel Implementation

class ProfileViewModel: ProfileViewModelProtocol {
    
    // MARK: - Properties
    
    var onProfileStateChange: ((ProfileState) -> Void)?
    
    weak var navigationDelegate: ProfileViewModelNavigationDelegate?
    
    init(navigationDelegate: ProfileViewModelNavigationDelegate? = nil) {
        self.navigationDelegate = navigationDelegate
    }
    
    // MARK: - Public Methods
    
    func fetchProfile() {
        onProfileStateChange?(.loading)
        
        // 1. Pega o usuário do Firebase Auth para nome e e-mail
        guard let firebaseUser = Auth.auth().currentUser, let userID = SessionManager.shared.userID else {
            onProfileStateChange?(.error(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado."])))
            return
        }
        
        // 2. Busca o resto dos dados no Supabase
        Task {
            do {
                let profiles: [ProfileData] = try await SupabaseManager.shared.client
                    .from("profiles")
                    .select()
                    .eq("id", value: userID)
                    .execute()
                    .value
                
                guard let supabaseProfile = profiles.first else {
                    throw NSError(domain: "DatabaseError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Perfil não encontrado no Supabase."])
                }
                
                // 3. Combina os dados de ambas as fontes
                let userProfile = UserProfile(
                    name: firebaseUser.displayName ?? "Usuário",
                    email: firebaseUser.email ?? "E-mail não disponível",
                    level: supabaseProfile.experience ?? "Iniciante",
                    weight: "\(supabaseProfile.weight ?? 0) kg",
                    height: "\(supabaseProfile.height ?? 0) cm",
                    goal: supabaseProfile.goal,
                    daysPerWeek: "\(supabaseProfile.run_days?.count ?? 0) dias",
                    totalDistance: "0.0", // TODO: Calcular no futuro
                    totalRuns: "0"       // TODO: Calcular no futuro
                )
                
                // 4. Notifica a UI com o perfil completo
                await MainActor.run {
                    onProfileStateChange?(.loaded(profile: userProfile))
                }
                
            } catch {
                await MainActor.run {
                    onProfileStateChange?(.error(error))
                }
            }
        }
    }
    
    func didTapEditProfile() {
        navigationDelegate?.navigateToEditProfile()
    }
    
    func performLogout() {
        do {
            try Auth.auth().signOut()
            SessionManager.shared.logout() // Limpa nossa sessão local
            // O listener de autenticação no Router vai detectar a mudança e
            // automaticamente levar para a tela de Welcome.
        } catch let signOutError {
            print("Erro ao fazer logout: \(signOutError)")
            onProfileStateChange?(.error(signOutError))
        }
    }
    
    func refreshProfile() {
        fetchProfile()
    }
}
