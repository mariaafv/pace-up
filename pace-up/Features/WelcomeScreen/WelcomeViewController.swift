import UIKit

class WelcomeViewController: BaseViewController {
  private let baseView = WelcomeView()
  private let viewModel: WelcomeViewModelProtocol
  
  init(viewModel: WelcomeViewModelProtocol) {
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
    baseView.loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
    baseView.createAccountButton.addTarget(self, action: #selector(createAccountButtonTapped), for: .touchUpInside)
  }
  
  @objc func loginButtonTapped() {
    viewModel.navigateToLogin()
  }
  
  @objc func createAccountButtonTapped() {
    viewModel.navigateToCreateAccount()
  }
}
