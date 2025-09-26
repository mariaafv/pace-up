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
  var activeWorkoutsByWeek: [[WorkoutDay]]  { get set }
  
  func fetchData()
  func didTapCreatePlan()
}

class HomeViewModel: HomeViewModelProtocol {
  var onPlanStateChange: ((PlanState) -> Void)?
  var onGreetingUpdate: ((String) -> Void)?
  var activeWorkoutsByWeek: [[WorkoutDay]] = []
  
  private weak var navigationDelegate: HomeViewModelNavigationDelegate?
  private var plan: WorkoutPlan?
  
  init(navigationDelegate: HomeViewModelNavigationDelegate?) {
    self.navigationDelegate = navigationDelegate
  }
  
  func fetchData() {
      onGreetingUpdate?("Olá, Maria! 👋")
      onPlanStateChange?(.loading)
      
      guard let userID = SessionManager.shared.userID else {
          onPlanStateChange?(.error(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Usuário não encontrado"])))
          return
      }
      
      Task {
          do {
              let profiles: [ProfileInfo] = try await SupabaseManager.shared.client
                  .from("profiles")
                  .select("workout_plan, planGenerationError") // Pede apenas as colunas que precisamos
                  .eq("id", value: userID)
                  .execute()
                  .value

              // MUDANÇA: Movemos toda a lógica para dentro do MainActor.run,
              // que é executado após a busca no Supabase ser concluída.
              await MainActor.run {
                  guard let userProfile = profiles.first else {
                      // Se não encontrou o perfil, o usuário é novo e não tem plano.
                      onPlanStateChange?(.empty)
                      return
                  }
                  
                  // Agora, 'userProfile' está no escopo correto e podemos usá-la.
                  if let plan = userProfile.workout_plan {
                      self.plan = plan
                      self.processPlan() // Processa o plano para filtrar os treinos
                      onPlanStateChange?(.loaded(plan: plan))
                  } else if let errorMessage = userProfile.planGenerationError {
                      onPlanStateChange?(.error(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: errorMessage])))
                  } else {
                      // O perfil existe, mas ainda não tem um plano.
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
  
  private func processPlan() {
      guard let plan = self.plan else {
          activeWorkoutsByWeek = []
          return
      }
      
      let allWeeks = [plan.week1, plan.week2, plan.week3, plan.week4]
          .compactMap { $0 } // Remove semanas que possam ser nulas
          
      // Filtra cada semana para remover os dias de "Descanso"
      activeWorkoutsByWeek = allWeeks.map { week in
          return week.filter { workoutDay in
              guard let type = workoutDay.type else { return false }
              return !type.lowercased().contains("descanso")
          }
      }
  }

  func didTapCreatePlan() {
    navigationDelegate?.navigateToOnboarding()
  }
}
