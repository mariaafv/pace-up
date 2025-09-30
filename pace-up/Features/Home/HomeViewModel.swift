import Foundation

enum PlanState {
  case loading
  case empty
  case loaded(plan: WorkoutPlan)
  case error(Error)
}

protocol HomeViewModelNavigationDelegate: AnyObject {
  func navigateToOnboarding()
}

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

class HomeViewModel: HomeViewModelProtocol {
  var onPlanStateChange: ((PlanState) -> Void)?
  var onGreetingUpdate: ((String) -> Void)?
  
  private(set) var activeWorkoutsByWeek: [[WorkoutDay]] = []
  private(set) var selectedWeekIndex = 0
  
  var workoutsForSelectedWeek: [WorkoutDay] {
    guard selectedWeekIndex < activeWorkoutsByWeek.count else { return [] }
    return activeWorkoutsByWeek[selectedWeekIndex]
  }
  
  private weak var navigationDelegate: HomeViewModelNavigationDelegate?
  private var plan: WorkoutPlan?
  
  init(navigationDelegate: HomeViewModelNavigationDelegate?) {
    self.navigationDelegate = navigationDelegate
  }
  
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
            let hasActiveWorkouts = self.processPlan()
            
            if hasActiveWorkouts {
              onPlanStateChange?(.loaded(plan: plan))
            } else {
              onPlanStateChange?(.empty)
            }
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
    if let plan = self.plan {
      onPlanStateChange?(.loaded(plan: plan))
    }
  }
  
  func didTapCreatePlan() {
    navigationDelegate?.navigateToOnboarding()
  }
  
  private func processPlan() -> Bool {
    guard let plan = self.plan else {
      activeWorkoutsByWeek = []
      print("❌ DEBUG: 'processPlan' falhou porque o plano principal é nulo.")
      return false
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
    
    return !activeWorkoutsByWeek.flatMap { $0 }.isEmpty
  }
}
