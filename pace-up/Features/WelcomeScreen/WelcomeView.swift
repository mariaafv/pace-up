import UIKit

class WelcomeView: UIView {
  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 16
    stack.alignment = .center
    return stack
  }()
  
  private let topTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "PaceUp"
    label.font = .systemFont(ofSize: 22, weight: .bold)
    label.textColor = .appGreen
    return label
  }()
  
  private let iconImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "welcomeLogo")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let welcomeTitleLabel: UILabel = {
    let label = UILabel()
    
    let fullText = "Bem-vindo ao PaceUp"
    let boldText = "PaceUp"
    
    let attributedString = NSMutableAttributedString(
      string: fullText,
      attributes: [
        .font: UIFont.systemFont(ofSize: 34, weight: .medium),
        .foregroundColor: UIColor.text
      ]
    )
    
    if let boldRange = fullText.range(of: boldText) {
      let nsRange = NSRange(boldRange, in: fullText)
      attributedString.addAttributes([
        .font: UIFont.systemFont(ofSize: 34, weight: .bold),
        .foregroundColor: UIColor.appGreen
      ], range: nsRange)
    }
    
    label.attributedText = attributedString
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.text = "AI-powered custom running plans, tailored to your goals and fitness level."
    label.font = .systemFont(ofSize: 16, weight: .regular)
    label.textColor = .text
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  
  let createAccountButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Criar conta", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
    button.backgroundColor = .appGreen
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 28
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 18, weight: .regular)
    button.backgroundColor = .appYellow
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 28
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let footerLabel: UILabel = {
    let label = UILabel()
    label.text = "© 2025 PaceUp. Todos os direitos reservados."
    label.font = .systemFont(ofSize: 12, weight: .regular)
    label.textColor = .lightGray
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupView() {
    backgroundColor = .background
    setupHierarchy()
    setupConstraints()
  }
  
  private func setupHierarchy() {
    addSubview(mainStackView)
    addSubview(footerLabel)
    
    mainStackView.addArrangedSubview(topTitleLabel)
    mainStackView.addArrangedSubview(iconImageView)
    mainStackView.addArrangedSubview(welcomeTitleLabel)
    mainStackView.addArrangedSubview(subtitleLabel)
    mainStackView.addArrangedSubview(createAccountButton)
    mainStackView.addArrangedSubview(loginButton)
    
    mainStackView.setCustomSpacing(60, after: topTitleLabel)
    mainStackView.setCustomSpacing(8, after: welcomeTitleLabel)
    mainStackView.setCustomSpacing(40, after: subtitleLabel)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      mainStackView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: -20),
      mainStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 30),
      mainStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -30),
      
      iconImageView.heightAnchor.constraint(equalToConstant: 260),
      iconImageView.widthAnchor.constraint(equalToConstant: 260),
      
      createAccountButton.heightAnchor.constraint(equalToConstant: 56),
      createAccountButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
      
      loginButton.heightAnchor.constraint(equalToConstant: 56),
      loginButton.widthAnchor.constraint(equalTo: mainStackView.widthAnchor),
      
      footerLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -10),
      footerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor)
    ])
  }
}
