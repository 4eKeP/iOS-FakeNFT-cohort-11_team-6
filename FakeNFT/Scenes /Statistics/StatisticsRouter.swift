//
//  StatisticsRouter.swift
//  FakeNFT
//
//  Created by Глеб Капустин on 02.04.2024.
//

import UIKit
import SafariServices

protocol StatisticsRouter {
    func push(with input: StatisticsInput)
    func pop()
    func presentSFViewController(urlStr: String)
}

final class StatisticsRouterImpl: StatisticsRouter {
    private let navigationController: UINavigationController?
    private let assemblyBuilder: StatisticsAssemblyBuilder?
    
    init(navigationController: UINavigationController?, assemblyBuilder: StatisticsAssemblyBuilder?) {
        self.navigationController = navigationController
        self.assemblyBuilder = assemblyBuilder
    }
    
    func initialViewController(input: StatisticsInput? = nil) {
        guard let assemblyBuilder else { return }
        let vc = assemblyBuilder.build(with: input, router: self)
        navigationController?.viewControllers = [vc]
    }
    
    func push(with input: StatisticsInput) {
        guard let assemblyBuilder else { return }
        let vc = assemblyBuilder.build(with: input, router: self)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func presentSFViewController(urlStr: String) {
        if let url = URL(string: urlStr) {
            let vc = SFSafariViewController(url: url)
            navigationController?.present(vc, animated: true)
        }
    }
}

