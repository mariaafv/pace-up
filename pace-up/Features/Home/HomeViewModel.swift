import Foundation

// MARK: - Protocols and Enums

// O enum que define os possíveis estados da UI para a seção do plano de treino
enum PlanState {
  case loading
  case empty
  case loaded(plan: WorkoutPlan)
  case error(Error)
}

// O protocolo que o Router deve implementar para a navegação
protocol HomeViewModelNavigationDelegate: AnyObject {
  func navigateToOnboarding()
}

// A "face pública" do ViewModel que o ViewController vai usar
protocol HomeViewModelProtocol: AnyObject {
  var onPlanStateChange: ((PlanState) -> Void)? { get set }
  var onGreetingUpdate: ((String) -> Void)? { get set }
  var activeWorkoutsByWeek: [[WorkoutDay]] { get }
  var selectedWeekIndex: Int { get }
  var workoutsForSelectedWeek: [WorkoutDay] { get }
  
  func fetchData()
  func didTapCreatePlan()
  func didSelectWeek(at index: Int)
}

// MARK: - ViewModel Implementation

class HomeViewModel: HomeViewModelProtocol {
  
  // MARK: - Properties
  
  var onPlanStateChange: ((PlanState) -> Void)?
  var onGreetingUpdate: ((String) -> Void)?
  
  private(set) var activeWorkoutsByWeek: [[WorkoutDay]] = []
  private(set) var selectedWeekIndex = 0

  // Propriedade computada que facilita o acesso aos treinos da semana selecionada
  var workoutsForSelectedWeek: [WorkoutDay] {
      guard selectedWeekIndex < activeWorkoutsByWeek.count else { return [] }
      return activeWorkoutsByWeek[selectedWeekIndex]
  }
  
  private weak var navigationDelegate: HomeViewModelNavigationDelegate?
  private var plan: WorkoutPlan?
  
  // MARK: - Initializer
  
  init(navigationDelegate: HomeViewModelNavigationDelegate?) {
    self.navigationDelegate = navigationDelegate
  }
  
  // MARK: - Public Methods
  
  func fetchData() {
    
    if let userName = SessionManager.shared.userName, !userName.isEmpty {
      let firstName = userName.components(separatedBy: " ").first ?? userName
      onGreetingUpdate?("Olá, \(firstName)! 👋")
    } else {
      onGreetingUpdate?("Olá! 👋")
    }
      onPlanStateChange?(.loading)
      
      guard let userID = SessionManager.shared.userID else {
          onPlanStateChange?(.error(NSError(domain: "AuthError", code: 0, userInfo: [NSLocalizedDescriptionKey: "Usuário não encontrado"])))
          return
      }
      
      Task {
          do {
              let profiles: [ProfileInfo] = try await SupabaseManager.shared.client
                  .from("profiles")
                  .select("workout_plan, planGenerationError")
                  .eq("id", value: userID)
                  .execute()
                  .value

              await MainActor.run {
                  guard let userProfile = profiles.first else {
                      onPlanStateChange?(.empty)
                      return
                  }
                  
                  if let plan = userProfile.workout_plan {
                      self.plan = plan
                      self.processPlan()
                      onPlanStateChange?(.loaded(plan: plan))
                  } else if let errorMessage = userProfile.planGenerationError {
                      onPlanStateChange?(.error(NSError(domain: "PlanGenerationError", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                  } else {
                      onPlanStateChange?(.empty)
                  }
              }
          } catch {
              await MainActor.run {
                  onPlanStateChange?(.error(error))
              }
          }
      }
  }
  
  func didSelectWeek(at index: Int) {
      selectedWeekIndex = index
      // Notifica o ViewController que o estado mudou para que a lista de treinos seja redesenhada
      if let plan = self.plan {
          onPlanStateChange?(.loaded(plan: plan))
      }
  }

  func didTapCreatePlan() {
    navigationDelegate?.navigateToOnboarding()
  }
  
  // MARK: - Private Methods
  
  private func processPlan() {
      guard let plan = self.plan else {
          activeWorkoutsByWeek = []
          print("❌ DEBUG: 'processPlan' falhou porque o plano principal é nulo.")
          return
      }
      
      let allWeeks = [plan.week1, plan.week2, plan.week3, plan.week4]
          .compactMap { $0 }
          
      print("✅ DEBUG: Encontradas \(allWeeks.count) semanas no plano.")
          
      activeWorkoutsByWeek = allWeeks.map { week in
          return week.filter { workoutDay in
              guard let type = workoutDay.type else { return false }
              return !type.lowercased().contains("descanso")
          }
      }
      
      // Adicione este print para ver o resultado do filtro
      print("✅ DEBUG: Treinos ativos por semana após o filtro: \(activeWorkoutsByWeek.map { $0.count })")
  }}
