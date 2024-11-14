//
//  NavigationController.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

import UIKit

final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRootContoller()
    }
}

private extension NavigationController {
    
    func setupRootContoller() {
        let newsListController = NewsListViewController()
        viewControllers = [newsListController]
    }
}
