import UIKit

class PlanEmptyStateView: UIView {
  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .vertical
    stack.spacing = 12
    stack.alignment = .center
    stack.translatesAutoresizingMaskIntoConstraints = false
    return stack
  }()
  
  private let plusIconView: UIImageView = {
    let config = UIImage.SymbolConfiguration(pointSize: 24, weight: .light)
    let image = UIImage(systemName: "plus", withConfiguration: config)
    let iv = UIImageView(image: image)
    iv.tintColor = .appGreen
    iv.backgroundColor = UIColor.appGreen.withAlphaComponent(0.2)
    iv.contentMode = .center
    iv.translatesAutoresizingMaskIntoConstraints = false
    return iv
  }()
  
  private let titleLabel: UILabel = {
    let titleLabel = UILabel(text: "Nenhum plano encontrado", font: .systemFont(ofSize: 18, weight: .semibold), textColor: .label)
    titleLabel.text = "Nenhum plano encontrado"
    return titleLabel
  }()
  
  private let subtitleLabel: UILabel = {
    let subtitleLabel = UILabel(text: "Vamos criar seu primeiro plano de treino!", font: .systemFont(ofSize: 16), textColor: .secondaryLabel)
    subtitleLabel.text = "Vamos criar seu primeiro plano de treino!"
    subtitleLabel.numberOfLines = 0
    return subtitleLabel
  }()
  
  let createPlanButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Criar Plano", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
    
    var config = UIButton.Configuration.filled()
    config.image = UIImage(systemName: "sparkles")
    config.imagePadding = 8
    config.baseBackgroundColor = .appGreen.withAlphaComponent(0.2)
    config.baseForegroundColor = .appGreen
    config.cornerStyle = .capsule
    
    button.configuration = config
    return button
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    plusIconView.layer.cornerRadius = plusIconView.frame.width / 2
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    translatesAutoresizingMaskIntoConstraints = false
    mainStackView.addArrangedSubview(plusIconView)
    mainStackView.addArrangedSubview(titleLabel)
    mainStackView.addArrangedSubview(subtitleLabel)
    mainStackView.addArrangedSubview(createPlanButton)
    mainStackView.setCustomSpacing(24, after: subtitleLabel)
    
    addSubview(mainStackView)
  }
  
  func setupConstraints() {
    NSLayoutConstraint.activate([
      plusIconView.widthAnchor.constraint(equalToConstant: 60),
      plusIconView.heightAnchor.constraint(equalToConstant: 60),
      
      mainStackView.topAnchor.constraint(equalTo: topAnchor, constant: 40),
      mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
      mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
      mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
    ])
  }
}
