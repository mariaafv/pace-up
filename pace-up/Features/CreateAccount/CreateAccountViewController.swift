import UIKit

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
    print("createAccountButtonTapped")
  }
  
  @objc func loginButtonTapped() {
    print("loginButtonTapped")
  }
}

