import UIKit

class HomeView: UIView {
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
  
  lazy var topRowStack: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [distanceCard, runsCard])
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  lazy var bottomRowStack: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [timeCard, weekCard])
    stackView.axis = .horizontal
    stackView.spacing = 16
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  lazy var statsGridStack: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [topRowStack, bottomRowStack])
    stackView.axis = .vertical
    stackView.spacing = 16
    return stackView
  }()
  
  private let greetingLabel = UILabel(text: "", font: .systemFont(ofSize: 28, weight: .bold), textColor: .label)
  private let subtitleLabel = UILabel(text: "Pronto para sua próxima corrida?", font: .systemFont(ofSize: 17), textColor: .secondaryLabel)
  
  private let distanceCard = StatCardView(icon: UIImage(systemName: "mappin.and.ellipse"), title: "Distância Total", value: "0.0 km")
  private let runsCard = StatCardView(icon: UIImage(systemName: "trophy.fill"), title: "Corridas", value: "0")
  private let timeCard = StatCardView(icon: UIImage(systemName: "clock.fill"), title: "Tempo Total", value: "0h 0m")
  private let weekCard = StatCardView(icon: UIImage(systemName: "target"), title: "Semana Atual", value: "0/4")
  
  private let planHeaderView = UIView()
  
  private let myPlanLabel: UILabel = {
    let label = UILabel(text: "Meu Plano de Corrida", font: .systemFont(ofSize: 22, weight: .bold), textColor: .label)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  let weekSegmentedControl: UISegmentedControl = {
    let sc = UISegmentedControl(items: ["Semana 1", "Semana 2", "Semana 3", "Semana 4"])
    sc.translatesAutoresizingMaskIntoConstraints = false
    sc.selectedSegmentIndex = 0
    return sc
  }()
  
  let planEmptyStateView = PlanEmptyStateView()
  
  let weeklyWorkoutListStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 16
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.isHidden = true
    return stack
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    backgroundColor = .systemGroupedBackground
    setupHierarchy()
    setupConstraints()
  }
  
  private func setupHierarchy() {
    addSubview(scrollView)
    scrollView.addSubview(mainStackView)

    planHeaderView.addSubview(myPlanLabel)
    planHeaderView.addSubview(weekSegmentedControl)
    
    mainStackView.addArrangedSubview(greetingLabel)
    mainStackView.addArrangedSubview(subtitleLabel)
    mainStackView.addArrangedSubview(statsGridStack)
    mainStackView.addArrangedSubview(planHeaderView)
    mainStackView.addArrangedSubview(planEmptyStateView)
    mainStackView.addArrangedSubview(weeklyWorkoutListStackView)
    
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
      
      myPlanLabel.topAnchor.constraint(equalTo: planHeaderView.topAnchor),
      myPlanLabel.leadingAnchor.constraint(equalTo: planHeaderView.leadingAnchor),
      myPlanLabel.trailingAnchor.constraint(equalTo: planHeaderView.trailingAnchor),
      
      weekSegmentedControl.topAnchor.constraint(equalTo: myPlanLabel.bottomAnchor, constant: 16),
      weekSegmentedControl.leadingAnchor.constraint(equalTo: planHeaderView.leadingAnchor),
      weekSegmentedControl.trailingAnchor.constraint(equalTo: planHeaderView.trailingAnchor),
      weekSegmentedControl.bottomAnchor.constraint(equalTo: planHeaderView.bottomAnchor)
    ])
  }
  
  func setGreeting(text: String) {
    greetingLabel.text = text
  }
  
  func showEmptyPlanState() {
    planEmptyStateView.isHidden = false
    weekSegmentedControl.isHidden = true
    weeklyWorkoutListStackView.isHidden = true
  }
  
  func showWorkoutPlanList() {
    planEmptyStateView.isHidden = true
    weekSegmentedControl.isHidden = false
    weeklyWorkoutListStackView.isHidden = false
  }
}
