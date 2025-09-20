import Foundation
import FirebaseAuth

protocol CreateAccountNavigationDelegate: AnyObject {
  func didTapCreateAccount()
  func didTapLogin()
}

protocol CreateAccountViewModelProtocol: AnyObject {
  func callCreateAccount(email: String, password: String)
  func callLogin()
}

final class CreateAccountViewModel {
  private weak var navigationDelegate: CreateAccountNavigationDelegate?
  
  init(navigationDelegate: CreateAccountNavigationDelegate?) {
    self.navigationDelegate = navigationDelegate
  }
}

extension CreateAccountViewModel: CreateAccountViewModelProtocol {
  func callCreateAccount(email: String, password: String) {
    Auth.auth().createUser(withEmail: email, password: password) { [weak self] (result, error) in
      guard let self = self else { return }
      
      if let error = error {
        print("Erro ao criar o usuário: \(error.localizedDescription)")
      }
      
      print("Usuário registrado e logado: \(result?.user.uid)")
      navigationDelegate?.didTapCreateAccount()
    }
  }
  
  func callLogin() {
    navigationDelegate?.didTapLogin()
  }
}
