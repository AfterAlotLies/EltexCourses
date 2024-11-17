//
//  NewsListViewController.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

import UIKit
import Combine

final class NewsListViewController: UIViewController {
    
    private lazy var newsListView: NewsListView = {
        let view = NewsListView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel = NewsListViewModel()
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
}

private extension NewsListViewController {
    
    func setupBindings() {
        viewModel.$newsData
            .sink { [weak self] data in
                if let data = data {
                    self?.newsListView.setNewsData(data)
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$isLoading
            .sink { [weak self] isLoading in
                if isLoading {
                    self?.newsListView.setLoaderActive()
                } else {
                    self?.newsListView.setLoaderInactive()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$selectedCellData
            .sink { cellDataInfo in
                if let cellData = cellDataInfo {
                    let newInfoViewModel = NewInfoViewModel()
                    newInfoViewModel.getNewInfo(cellData)
                    let newInfoController = NewInfoViewController(viewModel: newInfoViewModel)
                    self.navigationController?.pushViewController(newInfoController, animated: true)
                }
            }
            .store(in: &subscriptions)
    }
    
    func setupController() {
        view.backgroundColor = .white
        view.addSubview(newsListView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            newsListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newsListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newsListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newsListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
