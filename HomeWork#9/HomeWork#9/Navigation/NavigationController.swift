//
//  NavigationController.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 27.11.2024.
//

import UIKit

final class NavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
    }
}

private extension NavigationController {
    
    func setupNavigation() {
        let networkManager: ImagesListNetworkProtocol = NetworkService()
        let imagesViewModel = ImagesListViewModel(networkManager: networkManager)
        let imageCellViewModel = ImageCellViewModel(networkManager: networkManager)
        let imagesListController = ImagesViewController(viewModel: imagesViewModel, imageCellViewModel: imageCellViewModel)
        viewControllers = [imagesListController]
    }
}
