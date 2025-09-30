import UIKit

class HomeViewController: BaseViewController {
  private var baseView: HomeView!
  private var viewModel: HomeViewModelProtocol?
  
  init(viewModel: HomeViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  @MainActor required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    baseView = HomeView()
    self.view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.title = "Início"
    setupBindings()
    setupTargets()
    
    viewModel?.fetchData()
  }
  
  private func setupBindings() {
    viewModel?.onGreetingUpdate = { [weak self] greeting in
      self?.baseView.setGreeting(text: greeting)
    }
    
    viewModel?.onPlanStateChange = { [weak self] state in
      DispatchQueue.main.async {
        self?.updatePlanSection(for: state)
      }
    }
  }
  
  private func setupTargets() {
    baseView.planEmptyStateView.createPlanButton.addTarget(self, action: #selector(didTapCreatePlan), for: .touchUpInside)
    baseView.weekSegmentedControl.addTarget(self, action: #selector(weekSegmentDidChange(_:)), for: .valueChanged)
  }
  
  @objc private func didTapCreatePlan() {
    viewModel?.didTapCreatePlan()
  }
  
  @objc private func weekSegmentDidChange(_ sender: UISegmentedControl) {
    viewModel?.didSelectWeek(at: sender.selectedSegmentIndex)
  }
  
  private func updatePlanSection(for state: PlanState) {
    switch state {
    case .loading:
      print("Carregando plano...")
      // TODO: Mostrar um spinner
    case .empty:
      print("Nenhum plano encontrado. Mostrando estado vazio.")
      baseView.showEmptyPlanState()
    case .loaded(_):
      print("Plano carregado! Populando a UI...")
      baseView.showWorkoutPlanList()
      baseView.weekSegmentedControl.selectedSegmentIndex = viewModel?.selectedWeekIndex ?? 0
      populateWeeklyWorkouts()
    case .error(let error):
      print("Erro ao carregar plano: \(error.localizedDescription)")
      // TODO: Mostrar uma view de erro
    }
  }
  
  private func populateWeeklyWorkouts() {
    baseView.weeklyWorkoutListStackView.arrangedSubviews.forEach { view in
      baseView.weeklyWorkoutListStackView.removeArrangedSubview(view)
      view.removeFromSuperview()
    }
    
    guard let workouts = viewModel?.workoutsForSelectedWeek, !workouts.isEmpty else {
      let emptyLabel = UILabel()
      emptyLabel.text = "Nenhum treino agendado para esta semana."
      emptyLabel.font = .systemFont(ofSize: 16)
      emptyLabel.textColor = .gray
      emptyLabel.numberOfLines = 0
      emptyLabel.textAlignment = .center
      baseView.weeklyWorkoutListStackView.addArrangedSubview(emptyLabel)
      return
    }
    
    for (_, workout) in workouts.enumerated() {
      let card = TodayWorkoutCardView()
      let weekNumber = (viewModel?.selectedWeekIndex ?? 0) + 1
      let todayWorkout = workout.toTodayWorkout(weekNumber: weekNumber)
      
      card.configure(with: todayWorkout) { [weak self] in
        print("Botão 'Começar Agora' tocado para o treino: \(todayWorkout.workoutType)")
      }
      card.translatesAutoresizingMaskIntoConstraints = false
      
      baseView.weeklyWorkoutListStackView.addArrangedSubview(card)
    }
    
    baseView.weeklyWorkoutListStackView.setNeedsLayout()
    baseView.weeklyWorkoutListStackView.layoutIfNeeded()
  }
}
