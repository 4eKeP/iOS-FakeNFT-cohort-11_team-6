import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    let controllersFactory = ControllersFactory()

    func scene(_ scene: UIScene, willConnectTo _: UISceneSession, options _: UIScene.ConnectionOptions) {

        guard let windowsScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowsScene)
        
     //   let servicesAssembly = ServicesAssembly(networkClient: DefaultNetworkClient(), nftStorage: NftStorageImpl())
        
        let tabBarController = controllersFactory.setupTabBarController()
        //TabBarController(controllersFactory: controllersFactory, servicesAssembly: servicesAssembly)

        window.rootViewController = UserDefaults.standard.isOnBoarded ? tabBarController : OnBoardingController()

        self.window = window

        window.makeKeyAndVisible()
    }
}
