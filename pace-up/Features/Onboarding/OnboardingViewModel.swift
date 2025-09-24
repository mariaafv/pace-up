import Foundation
import FirebaseAuth

protocol OnboardingNavigationDelegate: AnyObject {
  func navigateToNextStep()
  func didCompleteOnboarding()
}

protocol OnboardingViewModelProtocol: AnyObject {
  var experienceOptions: [String] { get }
  var goalOptions: [String] { get }
  var onProgressUpdate: ((Float) -> Void)? { get set }
  var weight: String? { get set }
  var height: String? { get set }
  var experience: String? { get set }
  var goal: String? { get set }
  var selectedDays: Set<String> { get set }
  
  func didTapNext()
}

final class OnboardingViewModel: OnboardingViewModelProtocol {
  private weak var navigationDelegate: OnboardingNavigationDelegate?
  private let worker: OnboardingWorkerProtocol
  
  private let totalSteps: Float = 5
  
  var onProgressUpdate: ((Float) -> Void)?
  
  let experienceOptions = ["Iniciante (Nunca corri)", "Amador (Corro às vezes)", "Experiente (Corro com frequência)"]
  let goalOptions = ["Perder peso", "Correr 5km", "Correr 10km", "Meia Maratona (21km)", "Maratona (42km)"]
  
  var weight: String? { didSet { calculateProgress() } }
  var height: String? { didSet { calculateProgress() } }
  var experience: String? { didSet { calculateProgress() } }
  var goal: String? { didSet { calculateProgress() } }
  var selectedDays: Set<String> = [] { didSet { calculateProgress() } }
  
  init(navigationDelegate: OnboardingNavigationDelegate?,
       worker: OnboardingWorkerProtocol = OnboardingWorker()) {
    self.navigationDelegate = navigationDelegate
    self.worker = worker
  }
  
  func didTapNext() {
    Task {
      await saveProfileAndGeneratePlan()
    }
  }
    
  private func saveProfileAndGeneratePlan() async {
    guard let user = Auth.auth().currentUser else {
      print("❌ Erro: Usuário não está logado.")
      // TODO: Notificar a UI sobre o erro (ex: self.state = .error(...))
      return
    }
    
    guard let token = try? await user.getIDToken() else {
      print("❌ Erro ao obter token do Firebase.")
      // TODO: Notificar a UI sobre o erro
      return
    }
    
    let profile = ProfileData(
      weight: Float(self.weight ?? "0") ?? 0,
      height: Int(self.height ?? "0") ?? 0,
      experience: self.experience ?? "Não informado",
      goal: self.goal ?? "Não informado",
      run_days: Array(self.selectedDays)
    )
    
    do {
      try await worker.saveProfileAndGeneratePlan(token: token, userId: user.uid, profileData: profile)
      
      print("✅ ViewModel recebeu sucesso do Worker.")
      
      await MainActor.run {
        self.navigationDelegate?.didCompleteOnboarding()
      }
    } catch {
      print("❌ ViewModel recebeu erro do Worker: \(error.localizedDescription)")
      // TODO: Notificar a UI sobre o erro (ex: mostrar um alerta)
    }
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
}
