import Foundation
import UIKit

final class Router {
  let navigationController: UINavigationController
  
  init() {
    self.navigationController = UINavigationController()
  }
  
  func start() {
    let viewModel = CreateAccountViewModel(navigationDelegate: self)
    let viewController = CreateAccountViewController(viewModel: viewModel)
    navigationController.viewControllers = [viewController]
  }
}

extension Router: CreateAccountNavigationDelegate {
  
}
