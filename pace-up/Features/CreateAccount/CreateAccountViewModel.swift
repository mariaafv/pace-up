import Foundation

protocol CreateAccountNavigationDelegate: AnyObject {
  
}

protocol CreateAccountViewModelProtocol: AnyObject {
  
}

final class CreateAccountViewModel {
  private weak var navigationDelegate: CreateAccountNavigationDelegate?
  
  init(navigationDelegate: CreateAccountNavigationDelegate?) {
    self.navigationDelegate = navigationDelegate
  }
}

extension CreateAccountViewModel: CreateAccountViewModelProtocol {
  
}
