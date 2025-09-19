import UIKit

class CreateAccountView: UIView {
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
    label.text = "Criar conta"
    label.font = .systemFont(ofSize: 28, weight: .bold)
    label.textColor = .darkGray
    return label
  }()
  
  let nameTextField = CustomTextField(placeholder: "Nome")
  let dobTextField = CustomTextField(placeholder: "Data de nascimento")
  let emailTextField = CustomTextField(placeholder: "Email", keyboardType: .emailAddress)
  let passwordTextField = CustomTextField(placeholder: "Senha", isSecure: true)
  let confirmPasswordTextField = CustomTextField(placeholder: "Confirme a senha", isSecure: true)
  
  let createAccountButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Criar conta", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 18, weight: .bold)
    button.backgroundColor = .appGreen
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 12
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let loginStackView: UIStackView = {
    let stack = UIStackView()
    stack.axis = .horizontal
    stack.spacing = 5
    stack.alignment = .center
    return stack
  }()
  
  private let alreadyHaveAccountLabel: UILabel = {
    let label = UILabel()
    label.text = "Já tem uma conta?"
    label.font = .systemFont(ofSize: 16)
    label.textColor = .gray
    return label
  }()
  
  let loginButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Login", for: .normal)
    button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
    button.setTitleColor(.appGreen, for: .normal)
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
    
    loginStackView.addArrangedSubview(alreadyHaveAccountLabel)
    loginStackView.addArrangedSubview(loginButton)
    
    mainStackView.addArrangedSubview(logoImageView)
    mainStackView.addArrangedSubview(titleLabel)
    mainStackView.addArrangedSubview(nameTextField)
    mainStackView.addArrangedSubview(dobTextField)
    mainStackView.addArrangedSubview(emailTextField)
    mainStackView.addArrangedSubview(passwordTextField)
    mainStackView.addArrangedSubview(confirmPasswordTextField)
    mainStackView.addArrangedSubview(createAccountButton)
    mainStackView.addArrangedSubview(loginStackView)
    
    mainStackView.setCustomSpacing(40, after: titleLabel)
    mainStackView.setCustomSpacing(60, after: confirmPasswordTextField)
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
      
      logoImageView.heightAnchor.constraint(equalToConstant: 120),
      
      nameTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      nameTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      nameTextField.heightAnchor.constraint(equalToConstant: 50),
      
      dobTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      dobTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      dobTextField.heightAnchor.constraint(equalToConstant: 50),
      
      emailTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      emailTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      emailTextField.heightAnchor.constraint(equalToConstant: 50),
      
      passwordTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      passwordTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      passwordTextField.heightAnchor.constraint(equalToConstant: 50),
      
      confirmPasswordTextField.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      confirmPasswordTextField.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
      
      createAccountButton.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 16),
      createAccountButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
      createAccountButton.heightAnchor.constraint(equalToConstant: 55)
    ])
  }
}
