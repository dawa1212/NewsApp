import UIKit
import SideMenu

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }

        let window = UIWindow(windowScene: windowScene)

        let newsController = UINavigationController(rootViewController: NewsController())


        window.rootViewController = newsController
        self.window = window
        window.makeKeyAndVisible()
    }
}
