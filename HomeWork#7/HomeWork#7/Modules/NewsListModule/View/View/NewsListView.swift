//
//  NewsListView.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

import UIKit
import Combine

final class NewsListView: UIView {
    
    private lazy var searchTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Start to search something.."
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 10
        return textField
    }()
    
    private lazy var newsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NewsListCell.self, forCellReuseIdentifier: NewsListCell.identifier)
        return tableView
    }()
    
    private var models: [NewsModel]?
    private let viewModel: NewsListViewModel
    private var subscriptions: Set<AnyCancellable> = []
        
    init(frame: CGRect, viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        setupBindings()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setNewsData(_ data: [NewsModel]) {
        models = data
        newsListTableView.reloadData()
    }
}


extension NewsListView: UITableViewDataSource {
    
    func setupBindings() {
        searchTextField.textPublisher
            .assign(to: \.textFieldKeyWord, on: viewModel)
            .store(in: &subscriptions)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let models = models else { return 0 }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.identifier, for: indexPath) as? NewsListCell,
        let newsModels = models else {
            return UITableViewCell()
        }
        let cellData = newsModels[indexPath.row]
        cell.configureCell(title: cellData.title,
                           dataPublished: cellData.dataPublished)
        return cell
    }
}

extension NewsListView: UITableViewDelegate {
    
}

private extension NewsListView {
    
    func setupView() {
        addSubview(searchTextField)
        addSubview(newsListTableView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            searchTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            newsListTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            newsListTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            newsListTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newsListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
