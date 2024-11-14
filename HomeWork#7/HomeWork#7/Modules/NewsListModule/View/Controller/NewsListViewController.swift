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
    private var newsModels: [NewsModel]?
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
            .sink { data in
                self.newsModels = data
                if let newsModels = self.newsModels {
                    self.newsListView.setNewsData(newsModels)
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
