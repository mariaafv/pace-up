import Foundation
import FirebaseAuth

protocol LoginViewModelNavigationDelegate: AnyObject {
  func callLoginSuccessfully()
  func callCreateAccount()
}

protocol LoginViewModelProtocol {
  func didTapLogin(email: String, password: String)
  func didTapCreateAccount()
}

class LoginViewModel {
  private weak var navigationDelegate: LoginViewModelNavigationDelegate?
  
  init(navigationDelegate: LoginViewModelNavigationDelegate?) {
    self.navigationDelegate = navigationDelegate
  }
}

extension LoginViewModel: LoginViewModelProtocol {
  func didTapLogin(email: String, password: String) {
    Auth.auth().signIn(withEmail: email, password: password) { [weak self] result, error in
      guard let self = self else { return }
      
      if let error = error {
        // Notifique o ViewController sobre o erro
        return
      }
      
      // Notifique o ViewController sobre o sucesso
      self.navigationDelegate?.callLoginSuccessfully()
    }
  }
  
  func didTapCreateAccount() {
    navigationDelegate?.callCreateAccount()
  }
}
