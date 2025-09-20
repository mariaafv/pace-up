import UIKit
import FirebaseCore
import FirebaseAuth

class CreateAccountViewController: BaseViewController {
  let baseView = CreateAccountView()
  let viewModel: CreateAccountViewModelProtocol
  
  init(viewModel: CreateAccountViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    view = baseView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupActions()
  }
  
  func setupActions() {
    baseView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
    baseView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
  }
  
  @objc func createAccountButtonTapped() {
    guard let email = baseView.emailTextField.text, !email.isEmpty,
          let password = baseView.passwordTextField.text, !password.isEmpty else {
        // Mostre um alerta para o usuário preencher todos os campos
        return
    }
    viewModel.callCreateAccount(email: email, password: password)
  }
  
  @objc func loginButtonTapped() {
    viewModel.callLogin()
  }
}

