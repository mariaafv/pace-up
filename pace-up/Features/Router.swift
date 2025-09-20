import Foundation
import UIKit
import Firebase
import FirebaseAuth

final class Router {
  let navigationController: UINavigationController
  var window: UIWindow?
  var authHandle: AuthStateDidChangeListenerHandle?
  
  init() {
    self.navigationController = UINavigationController()
  }
  
  func start() {
    let viewModel = WelcomeViewModel(navigationDelegate: self)
    let viewController = WelcomeViewController(viewModel: viewModel)
    navigationController.viewControllers = [viewController]
  }
}

// MARK: - WELCOME VIEW MODEL

extension Router: WelcomeViewModelNavigationDelegate {
  func navigateToCreateAccount() {
    let viewModel = CreateAccountViewModel(navigationDelegate: self)
    let viewController = CreateAccountViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func navigateToLogin() {
    let viewModel = LoginViewModel(navigationDelegate: self)
    let viewController = LoginViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: - CREATE ACCOUNT

extension Router: CreateAccountNavigationDelegate {
  func didTapCreateAccount() {
    print("criou a conta")
  }
  
  func didTapLogin() {
    let viewModel = LoginViewModel(navigationDelegate: self)
    let viewController = LoginViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: - LOGIN

extension Router: LoginViewModelNavigationDelegate {
  func callLoginSuccessfully() {
    print("logou")
  }
  
  func callCreateAccount() {
    let viewModel = CreateAccountViewModel(navigationDelegate: self)
    let viewController = CreateAccountViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: - FIREBASE

extension Router {
  func startAuthenticationListener() {
    authHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
      guard let self = self else { return }
      
      if let user = user {
        print("Usuário logado: \(user.uid)")
        // Implemente a navegação para a tela principal
        self.callLoginSuccessfully()
      } else {
        print("Nenhum usuário logado.")
      }
    }
  }
}
