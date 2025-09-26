import UIKit

class HomeViewController: BaseViewController {

    // MARK: - Properties
    
    // Propriedade para acessar a view principal de forma segura e com o tipo correto
    private var baseView: HomeView {
        return self.view as! HomeView
    }
    
    // Inicializa o ViewModel, passando o Router como delegado de navegação
    private lazy var viewModel: HomeViewModelProtocol = HomeViewModel(navigationDelegate: self.router)

    // Acessa o Router a partir do SceneDelegate para gerenciar a navegação
    private var router: Router? {
        return (self.view.window?.windowScene?.delegate as? SceneDelegate)?.router
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        self.view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Início"
        setupBindings()
        setupTargets()
        
        // Pede para o ViewModel buscar os dados iniciais
        viewModel.fetchData()
    }
    
    // MARK: - Setup
    
    private func setupBindings() {
        // "Ouve" as atualizações do ViewModel
        viewModel.onGreetingUpdate = { [weak self] greeting in
            self?.baseView.setGreeting(text: greeting)
        }

        viewModel.onPlanStateChange = { [weak self] state in
            // Garante que a UI seja atualizada na thread principal
            DispatchQueue.main.async {
                self?.updatePlanSection(for: state)
            }
        }
    }
    
    private func setupTargets() {
        // Conecta as ações do usuário (toques) aos métodos deste ViewController
        baseView.planEmptyStateView.createPlanButton.addTarget(self, action: #selector(didTapCreatePlan), for: .touchUpInside)
        baseView.weekSegmentedControl.addTarget(self, action: #selector(weekSegmentDidChange(_:)), for: .valueChanged)
    }
    
    // MARK: - Actions
    
    @objc private func didTapCreatePlan() {
        viewModel.didTapCreatePlan()
    }
    
    @objc private func weekSegmentDidChange(_ sender: UISegmentedControl) {
        viewModel.didSelectWeek(at: sender.selectedSegmentIndex)
    }
    
    // MARK: - UI Updates
    
    private func updatePlanSection(for state: PlanState) {
        switch state {
        case .loading:
            // TODO: Mostrar um spinner de carregamento
            print("Carregando plano...")
        case .empty:
            print("Nenhum plano encontrado.")
            baseView.showEmptyPlanState()
        case .loaded(let plan):
            print("Plano carregado!")
            baseView.showWorkoutPlanList()
            // Sincroniza o seletor com a semana selecionada no ViewModel
            baseView.weekSegmentedControl.selectedSegmentIndex = viewModel.selectedWeekIndex
            // Popula a lista de treinos com os dados filtrados
            populateWeeklyWorkouts()
        case .error(let error):
            // TODO: Mostrar uma view de erro com a mensagem
            print("Erro ao carregar plano: \(error.localizedDescription)")
        }
    }
    
    private func populateWeeklyWorkouts() {
        // Limpa a lista antiga
        baseView.weeklyWorkoutListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let workouts = viewModel.workoutsForSelectedWeek
        
        if workouts.isEmpty {
          let emptyLabel = UILabel(text: "", font: .systemFont(ofSize: 16), textColor: .gray)
            emptyLabel.text = "Nenhum treino agendado para esta semana."
            baseView.weeklyWorkoutListStackView.addArrangedSubview(emptyLabel)
        } else {
            for workout in workouts {
                let card = TodayWorkoutCardView()
                let weekNumber = viewModel.selectedWeekIndex + 1
                let todayWorkout = workout.toTodayWorkout(weekNumber: weekNumber)
                
                card.configure(with: todayWorkout) { [weak self] in
                    print("Botão 'Começar Agora' tocado para o treino: \(todayWorkout.workoutType)")
                    // self?.router?.navigateToLiveRun(with: todayWorkout)
                }
                baseView.weeklyWorkoutListStackView.addArrangedSubview(card)
            }
        }
    }
}
