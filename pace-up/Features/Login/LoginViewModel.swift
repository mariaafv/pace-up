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
      guard self != nil else { return }
      SessionManager.shared.userID = result?.user.uid
      if error != nil {
        // Notifique o ViewController sobre o erro
        return
      }
    }
  }
  
  func didTapCreateAccount() {
    navigationDelegate?.callCreateAccount()
  }
}
