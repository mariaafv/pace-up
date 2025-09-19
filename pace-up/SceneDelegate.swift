import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
//  var router: Router?
  
  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(windowScene: windowScene)

//    let router = Router()
//    _ = router.start()

    window.rootViewController = CreateAccountViewController()
    window.makeKeyAndVisible()

    self.window = window
//    self.router = router
  }
}
