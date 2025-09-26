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
    private let weekCard = StatCardView(icon: UIImage(systemName: "target"), title: "Semana Atual", value: "1/4")
    
    // MARK: - Plan Section Components
    private let myPlanLabel: UILabel = {
      let label = UILabel(text: "a", font: .systemFont(ofSize: 28, weight: .bold), textColor: .label)
        label.text = "Meu Plano de Corrida"
        return label
    }()
    
    // A view de estado vazio, para quando não há plano
    let planEmptyStateView = PlanEmptyStateView()
    
    // O container para o plano de treino quando ele existe
    private let planContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true // Começa escondido
        return view
    }()
    
    // A CollectionView paginada para as semanas
    let weeklyPlanCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        // O tamanho de cada célula será definido no ViewController
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.isPagingEnabled = true // Habilita o efeito de "passar para o lado"
        return cv
    }()
    
    // O indicador de página (as bolinhas)
    let pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.translatesAutoresizingMaskIntoConstraints = false
      pc.currentPageIndicatorTintColor = .appGreen
        pc.pageIndicatorTintColor = .systemGray4
        pc.numberOfPages = 4 // Valor inicial
        return pc
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
        
        greetingLabel.text = "Olá, Maria! 👋"
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
        
        // Monta a seção do plano de treino (CollectionView + PageControl)
        planContainerView.addSubview(weeklyPlanCollectionView)
        planContainerView.addSubview(pageControl)
        
        // Adiciona tudo à stack view principal
        mainStackView.addArrangedSubview(greetingLabel)
        mainStackView.addArrangedSubview(subtitleLabel)
        mainStackView.addArrangedSubview(statsGridStack)
        mainStackView.addArrangedSubview(myPlanLabel)
        mainStackView.addArrangedSubview(planEmptyStateView) // Começa com o estado vazio visível
        mainStackView.addArrangedSubview(planContainerView)   // O container do plano começa escondido
        
        mainStackView.setCustomSpacing(8, after: greetingLabel)
        mainStackView.setCustomSpacing(24, after: myPlanLabel)
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
            
            // Constraints para a seção do plano de treino
            weeklyPlanCollectionView.topAnchor.constraint(equalTo: planContainerView.topAnchor),
            weeklyPlanCollectionView.leadingAnchor.constraint(equalTo: planContainerView.leadingAnchor),
            weeklyPlanCollectionView.trailingAnchor.constraint(equalTo: planContainerView.trailingAnchor),
            weeklyPlanCollectionView.heightAnchor.constraint(equalToConstant: 250), // Altura ajustável conforme necessidade

            pageControl.topAnchor.constraint(equalTo: weeklyPlanCollectionView.bottomAnchor, constant: 8),
            pageControl.centerXAnchor.constraint(equalTo: planContainerView.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: planContainerView.bottomAnchor),
        ])
    }
    
    // MARK: - Public Methods for ViewController
    
    func setGreeting(text: String) {
        greetingLabel.text = text
    }

    /// Mostra a view de estado vazio e esconde a lista de treinos
    func showEmptyPlanState() {
        planEmptyStateView.isHidden = false
        planContainerView.isHidden = true
    }
    
    /// Mostra a lista de treinos e esconde a view de estado vazio
    func showWorkoutPlanList() {
        planEmptyStateView.isHidden = true
        planContainerView.isHidden = false
    }
}
