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
    startAuthenticationListener()
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
    let hasCompletedCreateAccount = UserDefaults.standard.bool(forKey: "hasCompletedCreateAccount")
    
    if hasCompletedCreateAccount {
      // vai para home
    } else {
      let viewModel = OnboardingViewModel(navigationDelegate: self)
      let viewController = OnboardingViewController(viewModel: viewModel)
      navigationController.pushViewController(viewController, animated: true)
    }
  }
  
  func callCreateAccount() {
    let viewModel = CreateAccountViewModel(navigationDelegate: self)
    let viewController = CreateAccountViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

extension Router: OnboardingNavigationDelegate {
  func navigateToNextStep() {
    //code
  }
  
  func didCompleteOnboarding() {
    UserDefaults.standard.set(true, forKey: "hasCompletedCreateAccount")
    
  }
}

// MARK: - FIREBASE

extension Router {
  func startAuthenticationListener() {
    authHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
      guard let self = self else { return }
      
      if let user = user {
        print("Usuário logado: \(user.uid)")
        SessionManager.shared.userID = user.uid
        self.callLoginSuccessfully()
      } else {
        let viewModel = WelcomeViewModel(navigationDelegate: self)
        let viewController = WelcomeViewController(viewModel: viewModel)
        navigationController.viewControllers = [viewController]
      }
    }
  }
}
