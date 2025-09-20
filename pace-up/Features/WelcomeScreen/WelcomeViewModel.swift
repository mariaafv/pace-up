import Foundation

protocol WelcomeViewModelNavigationDelegate: AnyObject {
  func navigateToLogin()
  func navigateToCreateAccount()
}

protocol WelcomeViewModelProtocol: AnyObject {
  func navigateToLogin()
  func navigateToCreateAccount()
}

class WelcomeViewModel {
  private weak var navigationDelegate: WelcomeViewModelNavigationDelegate?
  
  init(navigationDelegate: WelcomeViewModelNavigationDelegate?) {
    self.navigationDelegate = navigationDelegate
  }
}

extension WelcomeViewModel: WelcomeViewModelProtocol {
  func navigateToLogin() {
    navigationDelegate?.navigateToLogin()
  }
  
  func navigateToCreateAccount() {
    navigationDelegate?.navigateToCreateAccount()
  }
}
