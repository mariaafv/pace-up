import Foundation
import FirebaseFirestore

protocol WorkoutPlanViewModelProtocol: AnyObject {
  var calendarDays: [(dayNumber: String, dayOfWeek: String, date: Date)] { get }
  var onStateChange: ((WorkoutPlanViewModel.State) -> Void)? { get set }
  
  func fetchWorkoutPlan()
  func selectDate(at index: Int)
  
  func numberOfSections() -> Int
  func titleForSection(_ section: Int) -> String
  func workouts(for section: Int) -> [WorkoutDay]
}

protocol WorkoutPlanNavigationDelegate: AnyObject {
  // Adicionar funções de navegação aqui no futuro, como por exemplo:
  // func navigateToWorkoutDetails(_ workout: WorkoutDay)
}

class WorkoutPlanViewModel: WorkoutPlanViewModelProtocol {
  
  // MARK: - State Management
  
  // Enum para controlar todos os possíveis estados da tela
  enum State {
    case loading
    case empty(message: String)
    case loaded(plan: WorkoutPlan)
    case error(Error)
  }
  
  // Propriedade que armazena o estado atual.
  // O 'didSet' notifica o ViewController sempre que o estado muda.
  private(set) var state: State = .loading {
    didSet {
      onStateChange?(state)
    }
  }
  
  // Callback para o ViewController se registrar e "ouvir" as mudanças de estado.
  var onStateChange: ((State) -> Void)?
  
  // MARK: - Properties
  
  private weak var navigationDelegate: WorkoutPlanNavigationDelegate?
  private var plan: WorkoutPlan? // Armazena o plano de treino completo
  
  // Propriedades do Calendário
  private(set) var calendarDays: [(dayNumber: String, dayOfWeek: String, date: Date)] = []
  private(set) var selectedDate: Date = Date()
  
  // MARK: - Initializer
  
  init(navigationDelegate: WorkoutPlanNavigationDelegate? = nil) {
    self.navigationDelegate = navigationDelegate
    // Gera os dias do calendário assim que o ViewModel é criado.
    generateDaysForCurrentMonth()
  }
  
  // MARK: - Public Methods (Ações que o ViewController pode chamar)
  
  func fetchWorkoutPlan() {
    self.state = .loading
    
    guard let userID = SessionManager.shared.userID else {
      self.state = .error(NSError(domain: "WorkoutPlanViewModel", code: 401, userInfo: [NSLocalizedDescriptionKey: "Usuário não autenticado."]))
      return
    }
    
    let db = Firestore.firestore()
    db.collection("users").document(userID).getDocument { [weak self] document, error in
      guard let self = self else { return }
      
      if let error = error {
        self.state = .error(error)
        return
      }
      
      guard let document = document, document.exists, let data = document.data() else {
        self.state = .empty(message: "Documento do usuário não encontrado.")
        return
      }
      
      if let planData = data["workoutPlan"] {
        do {
          // Decodifica os dados do Firestore para as nossas structs Swift
          let plan = try Firestore.Decoder().decode(WorkoutPlan.self, from: planData)
          self.plan = plan
          self.state = .loaded(plan: plan)
          print(plan)
        } catch {
          self.state = .error(error)
        }
      } else if let errorMessage = data["planGenerationError"] as? String {
        self.state = .empty(message: "Houve um erro ao gerar seu plano: \(errorMessage)")
      } else {
        self.state = .empty(message: "Seu plano está sendo gerado pela nossa IA. Volte em alguns instantes!")
      }
    }
  }
  
  func selectDate(at index: Int) {
    guard index < calendarDays.count else { return }
    self.selectedDate = calendarDays[index].date
    // TODO: Adicionar lógica para filtrar a lista de treinos com base na data selecionada.
    print("Data selecionada: \(self.selectedDate)")
  }
  
  // MARK: - Private Methods (Lógica interna do ViewModel)
  
  private func generateDaysForCurrentMonth() {
    let calendar = Calendar.current
    let today = Date()
    
    guard let monthInterval = calendar.dateInterval(of: .month, for: today) else { return }
    let startDate = monthInterval.start
    let endDate = monthInterval.end
    
    let dateFormatterNumber = DateFormatter()
    dateFormatterNumber.dateFormat = "d"
    
    let dateFormatterWeek = DateFormatter()
    dateFormatterWeek.locale = Locale(identifier: "pt_BR")
    dateFormatterWeek.dateFormat = "E"
    
    var currentDate = startDate
    while currentDate < endDate {
      let dayNumber = dateFormatterNumber.string(from: currentDate)
      var dayOfWeek = dateFormatterWeek.string(from: currentDate).uppercased()
      dayOfWeek = String(dayOfWeek.prefix(3))
      
      calendarDays.append((dayNumber, dayOfWeek, currentDate))
      
      if let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) {
        currentDate = nextDay
      } else {
        break
      }
    }
  }
  
  // MARK: - Data Source Helpers (Para a UITableView/UICollectionView)
  
  func numberOfSections() -> Int {
    return plan != nil ? 4 : 0
  }
  
  func titleForSection(_ section: Int) -> String {
    return "Semana \(section + 1)"
  }
  
  func workouts(for section: Int) -> [WorkoutDay] {
    guard let plan = plan else { return [] }
    switch section {
    case 0: return plan.week1
    case 1: return plan.week2
    case 2: return plan.week3
    case 3: return plan.week4
    default: return []
    }
  }
}
