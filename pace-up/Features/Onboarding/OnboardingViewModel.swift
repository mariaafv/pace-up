import Foundation
import FirebaseFirestore

protocol OnboardingNavigationDelegate: AnyObject {
  func navigateToNextStep()
}

protocol OnboardingViewModelProtocol: AnyObject {
  var experienceOptions: [String] { get }
  var goalOptions: [String] { get }
  
  var weight: String? { get set }
  var height: String? { get set }
  var experience: String? { get set }
  var goal: String? { get set }
  var onProgressUpdate: ((Float) -> Void)? { get set }
  var selectedDays: Set<String> { get set }
  
  func didTapNext()
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
  private weak var navigationDelegate: OnboardingNavigationDelegate?
  private let totalSteps: Float = 5
  
  var onProgressUpdate: ((Float) -> Void)?
  
  let experienceOptions = ["Iniciante (Nunca corri)", "Amador (Corro às vezes)", "Experiente (Corro com frequência)"]
  let goalOptions = ["Perder peso", "Correr 5km", "Correr 10km", "Meia Maratona (21km)", "Maratona (42km)"]
  let dayOptions = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sáb"]
  
  var weight: String? { didSet { calculateProgress() } }
  var height: String? { didSet { calculateProgress() } }
  var experience: String? { didSet { calculateProgress() } }
  var goal: String? { didSet { calculateProgress() } }
  
  var selectedDays: Set<String> = [] { didSet { calculateProgress() } }
  
  init(navigationDelegate: OnboardingNavigationDelegate?) {
    self.navigationDelegate = navigationDelegate
  }
  
  func didTapNext() {
    let data: [String: Any] = [
      "weight": weight,
      "height": height,
      "goal": goal,
      "experience": experience,
      "runDays": Array(selectedDays)]
    print("DEBUG: Dias selecionados: \(selectedDays)")
    saveOnboardingData(profileData: data)
    navigationDelegate?.navigateToNextStep()
  }
  
  private func calculateProgress() {
    var completedSteps: Float = 0
    
    if let w = weight, !w.isEmpty { completedSteps += 1 }
    if let h = height, !h.isEmpty { completedSteps += 1 }
    if experience != nil { completedSteps += 1 }
    if goal != nil { completedSteps += 1 }
    if !selectedDays.isEmpty { completedSteps += 1 }
    
    let progress = completedSteps / totalSteps
    onProgressUpdate?(progress)
  }
  
  func saveOnboardingData(profileData: [String: Any]) {
    guard let userID = SessionManager.shared.userID else { return }
    
    let db = Firestore.firestore()
    
    db.collection("users").document(userID).setData(profileData, merge: true) { error in
      if let error = error {
        print("Erro ao salvar perfil: \(error.localizedDescription)")
      } else {
        print("Perfil do usuário salvo com sucesso!")
        // Marca que o onboarding foi concluído
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
      }
    }
  }
}
