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
    self.navigationController.setNavigationBarHidden(true, animated: false)
  }
  
  func start() {
    startAuthenticationListener()
  }
  
  private func showMainApp() {
    let tabBarController = UITabBarController()
    
    let viewModel = WorkoutPlanViewModel()
    let planVC = WorkoutPlanViewController(viewModel: viewModel)
    let planNavController = UINavigationController(rootViewController: planVC)
    planNavController.tabBarItem = UITabBarItem(title: "Plano", image: UIImage(systemName: "calendar"), tag: 0)
    
    let runsVC = UIViewController()
    runsVC.view.backgroundColor = .systemBackground
    runsVC.title = "Minhas Corridas"
    let runsNavController = UINavigationController(rootViewController: runsVC)
    runsNavController.tabBarItem = UITabBarItem(title: "Corridas", image: UIImage(systemName: "figure.run"), tag: 1)
    
    let profileVC = UIViewController()
    profileVC.view.backgroundColor = .systemBackground
    profileVC.title = "Perfil"
    let profileNavController = UINavigationController(rootViewController: profileVC)
    profileNavController.tabBarItem = UITabBarItem(title: "Perfil", image: UIImage(systemName: "person.fill"), tag: 2)
    
    tabBarController.viewControllers = [planNavController, runsNavController, profileNavController]
    tabBarController.tabBar.tintColor = .appGreen
    tabBarController.tabBar.backgroundColor = .systemBackground
    
    navigationController.setViewControllers([tabBarController], animated: true)
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
    let hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
    
    if hasCompletedOnboarding {
      showMainApp()
    } else {
      let viewModel = OnboardingViewModel(navigationDelegate: self)
      let viewController = OnboardingViewController(viewModel: viewModel)
      navigationController.setViewControllers([viewController], animated: true)
    }
  }
  
  func callCreateAccount() {
    let viewModel = CreateAccountViewModel(navigationDelegate: self)
    let viewController = CreateAccountViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
}

// MARK: - ONBOARDING

extension Router: OnboardingNavigationDelegate {
  func navigateToNextStep() {
    let viewModel = WorkoutPlanViewModel()
    let viewController = WorkoutPlanViewController(viewModel: viewModel)
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func didCompleteOnboarding() {
    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
    showMainApp()
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
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.setNavigationBarHidden(true, animated: false)
      }
    }
  }
}
