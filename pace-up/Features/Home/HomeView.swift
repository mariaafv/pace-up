import UIKit

class HomeView: UIView {

    // MARK: - UI Components
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    private let mainStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 24
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
  private let greetingLabel = UILabel(text: "", font: .systemFont(ofSize: 28, weight: .bold), textColor: .label)
  private let subtitleLabel = UILabel(text: "", font: .systemFont(ofSize: 17), textColor: .secondaryLabel)
    
    // MARK: - Stat Cards
    private let distanceCard = StatCardView(icon: UIImage(systemName: "mappin.and.ellipse"), title: "Distância Total", value: "0.0 km")
    private let runsCard = StatCardView(icon: UIImage(systemName: "trophy.fill"), title: "Corridas", value: "0")
    private let timeCard = StatCardView(icon: UIImage(systemName: "clock.fill"), title: "Tempo Total", value: "0h 0m")
    private let weekCard = StatCardView(icon: UIImage(systemName: "target"), title: "Semana Atual", value: "0/4")

    // MARK: - Plan Section Components
    private let planHeaderView = UIView() // Container para o título e o seletor
    
    private let myPlanLabel: UILabel = {
      let label = UILabel(text: "a", font: .systemFont(ofSize: 22, weight: .bold), textColor: .label)
        label.text = "Meu Plano de Corrida"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // O novo seletor de semanas
    let weekSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Semana 1", "Semana 2", "Semana 3", "Semana 4"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.selectedSegmentIndex = 0 // Começa com a primeira semana
        return sc
    }()
    
    let planEmptyStateView = PlanEmptyStateView()
    
    // A StackView que conterá a lista de cards de treino da semana
    let weeklyWorkoutListStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.isHidden = true // Começa escondida
        return stack
    }()

    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupView() {
        backgroundColor = .systemGroupedBackground
        setupHierarchy()
        setupConstraints()
        
        // Define textos iniciais
        greetingLabel.text = "Olá!"
        subtitleLabel.text = "Pronto para sua próxima corrida?"
    }
    
    private func setupHierarchy() {
        addSubview(scrollView)
        scrollView.addSubview(mainStackView)
        
        // Monta a grade de estatísticas
        let topRowStack = UIStackView(arrangedSubviews: [distanceCard, runsCard])
        topRowStack.axis = .horizontal
        topRowStack.spacing = 16
        topRowStack.distribution = .fillEqually
        
        let bottomRowStack = UIStackView(arrangedSubviews: [timeCard, weekCard])
        bottomRowStack.axis = .horizontal
        bottomRowStack.spacing = 16
        bottomRowStack.distribution = .fillEqually
        
        let statsGridStack = UIStackView(arrangedSubviews: [topRowStack, bottomRowStack])
        statsGridStack.axis = .vertical
        statsGridStack.spacing = 16
        
        // Monta o cabeçalho do plano de treino
        planHeaderView.addSubview(myPlanLabel)
        planHeaderView.addSubview(weekSegmentedControl)
        
        // Adiciona tudo à stack view principal na ordem correta
        mainStackView.addArrangedSubview(greetingLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(statsGridStack)
        mainStackView.addArrangedSubview(planHeaderView)
        mainStackView.addArrangedSubview(planEmptyStateView)
        mainStackView.addArrangedSubview(weeklyWorkoutListStackView)
        
        // Ajusta espaçamentos customizados
        mainStackView.setCustomSpacing(8, after: greetingLabel)
        mainStackView.setCustomSpacing(32, after: statsGridStack)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
            mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
            mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
            mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
            
            // Constraints para o cabeçalho do plano
            myPlanLabel.topAnchor.constraint(equalTo: planHeaderView.topAnchor),
            myPlanLabel.leadingAnchor.constraint(equalTo: planHeaderView.leadingAnchor),
            myPlanLabel.trailingAnchor.constraint(equalTo: planHeaderView.trailingAnchor),
            
            weekSegmentedControl.topAnchor.constraint(equalTo: myPlanLabel.bottomAnchor, constant: 16),
            weekSegmentedControl.leadingAnchor.constraint(equalTo: planHeaderView.leadingAnchor),
            weekSegmentedControl.trailingAnchor.constraint(equalTo: planHeaderView.trailingAnchor),
            weekSegmentedControl.bottomAnchor.constraint(equalTo: planHeaderView.bottomAnchor)
        ])
    }
    
    // MARK: - Public Methods for ViewController
    
    func setGreeting(text: String) {
        greetingLabel.text = text
    }

    /// Mostra a view de estado vazio e esconde a lista de treinos
    func showEmptyPlanState() {
        planEmptyStateView.isHidden = false
        weekSegmentedControl.isHidden = true // Esconde o seletor de semanas também
        weeklyWorkoutListStackView.isHidden = true
    }
    
    /// Mostra a lista de treinos e esconde a view de estado vazio
    func showWorkoutPlanList() {
        planEmptyStateView.isHidden = true
        weekSegmentedControl.isHidden = false
        weeklyWorkoutListStackView.isHidden = false
    }
}
