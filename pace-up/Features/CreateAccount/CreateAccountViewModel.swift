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
      
      let changeRequest = result?.user.createProfileChangeRequest()
      changeRequest?.displayName = result?.user.displayName
      changeRequest?.commitChanges { error in
        if let error = error {
            print("Erro ao salvar o nome do usuário: \(error.localizedDescription)")
        } else {
          print("✅ Nome de usuário '\(result?.user.displayName)' salvo com sucesso!")
        }
    }
      
      print("Usuário registrado e logado: \(result?.user.uid)")
      SessionManager.shared.userID = result?.user.uid
      navigationDelegate?.didTapCreateAccount()
    }
  }
  
  func callLogin() {
    navigationDelegate?.didTapLogin()
  }
}
