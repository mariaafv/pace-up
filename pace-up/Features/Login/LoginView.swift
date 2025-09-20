import UIKit

class LoginView: UIView {
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  private let contentView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let mainStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.axis = .vertical
    stack.spacing = 20
    stack.alignment = .center
    return stack
  }()
  
  private let logoImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "logo")
    imageView.contentMode = .scaleAspectFit
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Login"
    label.font = .systemFont(ofSize: 28, weight: .bold)
    label.textColor = .text
    return label
  }()
  
  let emailTextField = CustomTextField(placeholder: "Email")
  let passwordTextField = CustomTextField(placeholder: "Senha", isSecure: true)
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Entrar", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
    button.backgroundColor = .background
    button.setTitleColor(.text, for: .normal)
    button.layer.cornerRadius = 28
    button.layer.borderWidth = 2
    button.layer.borderColor = UIColor.appGreen.cgColor
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  let createAccountButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Criar conta", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 20, weight: .regular)
    button.backgroundColor = .appGreen
    button.setTitleColor(.background, for: .normal)
    button.layer.cornerRadius = 28
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
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
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(mainStackView)
    
    mainStackView.addArrangedSubview(logoImageView)
    mainStackView.addArrangedSubview(titleLabel)
    mainStackView.addArrangedSubview(emailTextField)
    mainStackView.addArrangedSubview(passwordTextField)
    mainStackView.addArrangedSubview(loginButton)
    mainStackView.addArrangedSubview(createAccountButton)
    
    mainStackView.setCustomSpacing(40, after: titleLabel)
    mainStackView.setCustomSpacing(60, after: passwordTextField)
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      scrollView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
      scrollView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
      scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
      
      contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
      contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor),
      
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
      mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
      
      logoImageView.heightAnchor.constraint(equalToConstant: 211),
      
      emailTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      emailTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      emailTextField.heightAnchor.constraint(equalToConstant: 50),
      
      passwordTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      passwordTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      passwordTextField.heightAnchor.constraint(equalToConstant: 50),
      
      loginButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      loginButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      loginButton.heightAnchor.constraint(equalToConstant: 56),

      createAccountButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      createAccountButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      createAccountButton.heightAnchor.constraint(equalToConstant: 56)
    ])
  }
}
