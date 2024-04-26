import UIKit

final class TabBarController: UITabBarController {
    private let profileTabBarItem = UITabBarItem(
        title: L10n.TabBar.profileTabBarTitle,
        image: UIImage(named: "profile_tab_inactive"),
        tag: 0
    )
    var controllersFactory: ControllersFactory
    var servicesAssembly: ServicesAssembly!

    init(controllersFactory: ControllersFactory, servicesAssembly: ServicesAssembly) {
        self.controllersFactory = controllersFactory
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        

    private let cartTabBarItem = UITabBarItem(
        title: L10n.TabBar.cartTabBarTitle,
        image: UIImage(named: "Cart"),
        tag: 1
    )

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBars()

    }

    private func createNavigation(with title: String,
                                  and image: UIImage?,
                                  vc: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.tabBarItem.title = title
        nav.tabBarItem.image = image
        nav.viewControllers.first?.navigationItem.title = title

        return nav
    }
    
    private func createStatisticsVC() -> UIViewController {
        let navController = UINavigationController()
        let assemblyBuilder = StatisticsAssemblyBuilderImpl(networkClient: DefaultNetworkClient())
        let router = StatisticsRouterImpl(navigationController: navController, assemblyBuilder: assemblyBuilder)
        router.initialViewController()
        
        navController.title = L10n.TabBar.statisticTabBarTitle
        navController.tabBarItem.image = UIImage(systemName: "flag.2.crossed.fill")
        return navController
    }

    private func configureTabBars() {
        let profileViewController = ProfileViewController(
            servicesAssembly: servicesAssembly
        )

        let profileNavigationController = UINavigationController(
            rootViewController: profileViewController
        )

        profileViewController.tabBarItem = profileTabBarItem
        tabBar.unselectedItemTintColor = UIColor.black

        let profilePresenter = ProfilePresenter()
        profileViewController.presenter = profilePresenter
        profilePresenter.view = profileViewController

        let catalogNavigationItem = controllersFactory.setupController(of: ControllersType.catalogViewController)

        let statisticsController = createStatisticsVC()

        let cartViewController = UINavigationController(rootViewController: CartViewController(servicesAssembly: servicesAssembly))
        cartViewController.tabBarItem = cartTabBarItem

        self.setViewControllers([profileNavigationController, catalogNavigationItem, cartViewController, statisticsController], animated: true)

        tabBar.isTranslucent = false
        tabBar.backgroundColor = Asset.Colors.ypWhite.color
        tabBar.unselectedItemTintColor = Asset.Colors.ypBlack.color
        tabBar.tintColor = Asset.Colors.Universal.ypUniBlue.color
    }
}
