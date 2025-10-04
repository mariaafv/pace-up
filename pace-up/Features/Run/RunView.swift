import UIKit

class RunView: UIView {
  private let scrollView: UIScrollView = {
    let sv = UIScrollView()
    sv.translatesAutoresizingMaskIntoConstraints = false
    return sv
  }()
  
  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 24
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel(text: "Iniciar Corrida", font: .systemFont(ofSize: 28, weight: .bold), textColor: .label)
    label.textAlignment = .center
    return label
  }()
  private let tipView: UIView = {
    let view = UIView()
    view.backgroundColor = .appYellow.withAlphaComponent(0.2)
    view.layer.cornerRadius = 12
    
    let label = UILabel(text: "💡 Dica: Mantenha um ritmo confortável onde você ainda consegue manter uma conversa.", font: .systemFont(ofSize: 14), textColor: .secondaryLabel)
    label.textAlignment = .center
    label.numberOfLines = 0
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: view.topAnchor, constant: 12),
      label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -12),
      label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
      label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
    ])
    
    return view
  }()
  
  private let timeMetricCard = MetricCardView(icon: UIImage(systemName: "clock.fill"), title: "Tempo", value: "00:00")
  private let distanceMetricCard = MetricCardView(icon: UIImage(systemName: "location.fill"), title: "Distância (km)", value: "0.00")
  private let paceMetricCard = MetricCardView(icon: UIImage(systemName: "bolt.fill"), title: "Pace (min/km)", value: "0'00\"")
  private let caloriesMetricCard = MetricCardView(icon: UIImage(systemName: "flame.fill"), title: "Calorias", value: "0")
  
  let primaryActionButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.titleLabel?.font = .boldSystemFont(ofSize: 20)
    btn.layer.cornerRadius = 28
    return btn
  }()
  
  let secondaryActionButton: UIButton = {
    let btn = UIButton(type: .system)
    btn.translatesAutoresizingMaskIntoConstraints = false
    btn.setTitle("Finalizar", for: .normal)
    btn.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
    btn.layer.cornerRadius = 28
    return btn
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    updateUI(for: .ready)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updateMetrics(metrics: RunMetrics) {
    timeMetricCard.updateValue(metrics.formattedTime)
    distanceMetricCard.updateValue(metrics.formattedDistance)
    paceMetricCard.updateValue(metrics.formattedPace)
  }
  
  func updateUI(for state: RunState) {
    switch state {
    case .ready:
      primaryActionButton.setTitle("Iniciar", for: .normal)
      primaryActionButton.backgroundColor = .appGreen
      primaryActionButton.setTitleColor(.white, for: .normal)
      primaryActionButton.isHidden = false
      secondaryActionButton.isHidden = true
    case .running:
      primaryActionButton.setTitle("Pausar", for: .normal)
      primaryActionButton.backgroundColor = .systemOrange
      secondaryActionButton.isHidden = false
    case .paused:
      primaryActionButton.setTitle("Retomar", for: .normal)
      primaryActionButton.backgroundColor = .appGreen
    case .finished:
      primaryActionButton.isHidden = true
      secondaryActionButton.isHidden = true
    }
  }
  
  private func setupView() {
    backgroundColor = .systemGroupedBackground
    setupHierarchy()
    setupConstraints()
  }
  
  private func setupHierarchy() {
    addSubview(scrollView)
    scrollView.addSubview(mainStackView)
    
    let topRow = UIStackView(arrangedSubviews: [timeMetricCard, distanceMetricCard])
    topRow.distribution = .fillEqually
    topRow.spacing = 16
    
    let bottomRow = UIStackView(arrangedSubviews: [paceMetricCard, caloriesMetricCard])
    bottomRow.distribution = .fillEqually
    bottomRow.spacing = 16
    
    let metricsGrid = UIStackView(arrangedSubviews: [topRow, bottomRow])
    metricsGrid.axis = .vertical
    metricsGrid.spacing = 16
    
    mainStackView.addArrangedSubview(titleLabel)
    mainStackView.addArrangedSubview(metricsGrid)
    mainStackView.addArrangedSubview(tipView)
    mainStackView.addArrangedSubview(primaryActionButton)
    mainStackView.addArrangedSubview(secondaryActionButton)
    
    mainStackView.setCustomSpacing(32, after: titleLabel)
    mainStackView.setCustomSpacing(32, after: metricsGrid)
    mainStackView.setCustomSpacing(32, after: tipView)
    mainStackView.setCustomSpacing(16, after: primaryActionButton)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      
      mainStackView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor, constant: 16),
      mainStackView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor, constant: 20),
      mainStackView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor, constant: -20),
      mainStackView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor, constant: -20),
      mainStackView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor, constant: -40),
      
      primaryActionButton.heightAnchor.constraint(equalToConstant: 56),
      secondaryActionButton.heightAnchor.constraint(equalToConstant: 44),
    ])
  }
}

// Helper: Card para exibir métricas
class MetricCardView: UIView {
  private let iconImageView: UIImageView = {
    let iv = UIImageView()
    iv.contentMode = .scaleAspectFit
    iv.tintColor = .appGreen
    return iv
  }()
  
  private let titleLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = .systemFont(ofSize: 14)
    lbl.textColor = .secondaryLabel
    return lbl
  }()
  
  private let valueLabel: UILabel = {
    let lbl = UILabel()
    lbl.font = .boldSystemFont(ofSize: 28)
    lbl.textColor = .label
    return lbl
  }()
  
  init(icon: UIImage?, title: String, value: String) {
    super.init(frame: .zero)
    self.iconImageView.image = icon
    self.titleLabel.text = title
    self.valueLabel.text = value
    setupUI()
  }
  
  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
  
  private func setupUI() {
    backgroundColor = .systemBackground
    layer.cornerRadius = 16
    translatesAutoresizingMaskIntoConstraints = false
    
    let stack = UIStackView(arrangedSubviews: [iconImageView, titleLabel, valueLabel])
    stack.axis = .vertical
    stack.alignment = .leading
    stack.spacing = 4
    stack.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(stack)
    
    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: topAnchor, constant: 16),
      stack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      stack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      stack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
      iconImageView.widthAnchor.constraint(equalToConstant: 24),
      iconImageView.heightAnchor.constraint(equalToConstant: 24)
    ])
  }
  
  func updateValue(_ value: String) {
    valueLabel.text = value
  }
}
