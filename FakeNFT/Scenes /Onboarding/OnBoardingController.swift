//
//  OnBoardingController.swift
//  FakeNFT
//
//  Created by admin on 18.04.2024.
//

import UIKit

final class OnBoardingController: UIPageViewController {
    private let controllersFactory = ControllersFactory()
    private var pages: [UIViewController] = []
    private var currentPageIndex = 0
    
    private let bottomButtonSpacing: CGFloat = 66
    private let buttonHeight: CGFloat = 60
    private let sideSpacing: CGFloat = 16
    private let topSpacing: CGFloat = 12
    private let labelTopSpacing: CGFloat = 230
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.transform = CGAffineTransform(scaleX: 2, y: 1)
        pageControl.preferredIndicatorImage = Asset.OnBoarding.paginationNoActive.image
        if #available(iOS 16.0, *) {
            pageControl.preferredCurrentPageIndicatorImage = Asset.OnBoarding.paginationActive.image
        } else {
        }
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(L10n.OnBoarding.onboardingButton, for: .normal)
        button.backgroundColor = Asset.Colors.Universal.ypUniBlack.color
        button.layer.cornerRadius = 16
        button.setTitleColor(Asset.Colors.Universal.ypUniWhite.color, for: .normal)
        button.titleLabel?.font = .bodyBold
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        delegate = self
        
        setupPagesAndButton()
    }
    
    @objc private func buttonTapped() {
        let tabBarController = controllersFactory.setupTabBarController()
        guard let window = UIApplication.shared.windows.first else { fatalError("Invalid Configuration") }
        UserDefaults.standard.isOnBoarded = true
        window.rootViewController = tabBarController
    }
}
    
private extension OnBoardingController {
    
    func setupPagesAndButton() {
        
        let page1 = createOnboardingPage(image: Asset.OnBoarding.onboardingImage1.image, labelText: L10n.OnBoarding.firstHeader, descriptionText: L10n.OnBoarding.firstDescription)
        let page2 = createOnboardingPage(image: Asset.OnBoarding.onboardingImage2.image, labelText: L10n.OnBoarding.secondHeader, descriptionText: L10n.OnBoarding.secondDescription)
        let page3 = createOnboardingPage(image: Asset.OnBoarding.onboardingImage3.image, labelText: L10n.OnBoarding.thirdHeader, descriptionText: L10n.OnBoarding.thirdDescription)
        
        pages.append(page1)
        pages.append(page2)
        pages.append(page3)
        
        if let firstPage = pages.first {
            setViewControllers([firstPage], direction: .forward, animated: true, completion: nil)
            button.isHidden = true
        }
        
        view.addSubview(pageControl)
        view.addSubview(button)
        
        NSLayoutConstraint.activate([
            pageControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topSpacing),
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomButtonSpacing),
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: sideSpacing),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -sideSpacing),
            button.heightAnchor.constraint(equalToConstant: buttonHeight)
        ])
    }
    
    func createOnboardingPage(image: UIImage, labelText: String, descriptionText: String) -> UIViewController {
        let onboardingVC = UIViewController()
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        onboardingVC.view.addSubview(imageView)
        
        let label = UILabel()
        label.text = labelText
        label.textColor = Asset.Colors.Universal.ypUniWhite.color
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        onboardingVC.view.addSubview(label)
        
        let description = UILabel()
        description.text = descriptionText
        description.numberOfLines = 2
        description.textColor = Asset.Colors.Universal.ypUniWhite.color
        description.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        description.textAlignment = .left
        description.translatesAutoresizingMaskIntoConstraints = false
        onboardingVC.view.addSubview(description)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: onboardingVC.view.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: onboardingVC.view.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: onboardingVC.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: onboardingVC.view.trailingAnchor),
            
            label.topAnchor.constraint(equalTo: onboardingVC.view.topAnchor, constant: labelTopSpacing),
            label.leadingAnchor.constraint(equalTo: onboardingVC.view.leadingAnchor, constant: sideSpacing),
            label.trailingAnchor.constraint(equalTo: onboardingVC.view.trailingAnchor, constant: -sideSpacing),
            
            description.topAnchor.constraint(equalTo: label.bottomAnchor, constant: topSpacing),
            description.leadingAnchor.constraint(equalTo: onboardingVC.view.leadingAnchor, constant: sideSpacing),
            description.trailingAnchor.constraint(equalTo: onboardingVC.view.trailingAnchor, constant: -sideSpacing)
        ])
        
        return onboardingVC
    }
}

// MARK: - UIPageViewControllerDataSource
extension OnBoardingController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
                
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        
        guard nextIndex < pages.count else {
            return nil
        }
                
        return pages[nextIndex]
    }
}

// MARK: - UIPageViewControllerDelegate
extension OnBoardingController: UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
            
            currentPageIndex = currentIndex
            button.isHidden = currentIndex != 2
        }
    }
}
