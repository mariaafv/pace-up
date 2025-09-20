import Foundation
import UIKit
import FirebaseAuth

class LoginViewController: BaseViewController {
  let baseView = LoginView()
  let viewModel: LoginViewModelProtocol
  
  init(viewModel: LoginViewModelProtocol) {
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
    baseView.loginButton.addTarget(self, action: #selector(didTapLogin), for: .touchUpInside)
    baseView.createAccountButton.addTarget(self, action: #selector(didTapCreateAccount), for: .touchUpInside)
  }
  
  @objc func didTapLogin() {
    guard let email = baseView.emailTextField.text, !email.isEmpty,
          let password = baseView.passwordTextField.text, !password.isEmpty else {
      return
    }
    viewModel.didTapLogin(email: email, password: password)
  }
  
  @objc func didTapCreateAccount() {
    viewModel.didTapCreateAccount()
  }
}
