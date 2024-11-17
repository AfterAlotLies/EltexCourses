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
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 20))
        textField.leftViewMode = .always
        textField.leftView = leftView
        return textField
    }()
    
    private lazy var newsListTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false
        tableView.isHidden = true
        tableView.register(NewsListCell.self,
                           forCellReuseIdentifier: NewsListCell.identifier)
        return tableView
    }()
    
    private lazy var sortByDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sort by published date", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.addTarget(self, action: #selector(sortByPublishedDateTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sortByPopularityButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sort by popularity", for: .normal)
        button.titleLabel?.numberOfLines = 0
        button.addTarget(self, action: #selector(sortByPopularityTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var newsLoader: UIActivityIndicatorView = {
        let loader = UIActivityIndicatorView(style: .medium)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.isHidden = true
        return loader
    }()
    
    private let viewModel: NewsListViewModel
    private var findedNewsModels: [NewsModel]?
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
    
    func setLoaderActive() {
        newsLoader.isHidden = false
        newsLoader.startAnimating()
    }
    
    func setLoaderInactive() {
        newsLoader.stopAnimating()
        newsLoader.isHidden = true
        newsListTableView.isHidden = false
    }
    
    func setNewsData(_ data: [NewsModel]) {
        findedNewsModels = data
        newsListTableView.reloadData()
    }
}

extension NewsListView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let models = findedNewsModels else { return 0 }
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsListCell.identifier, for: indexPath) as? NewsListCell,
        let newsModels = findedNewsModels else {
            return UITableViewCell()
        }
        let cellData = newsModels[indexPath.row]
        cell.configureCell(title: cellData.title,
                           dataPublished: cellData.dataPublished)
        cell.selectionStyle = .none
        return cell
    }
}

extension NewsListView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newInfoModels = findedNewsModels else { return }
        let selectedCellData = newInfoModels[indexPath.row]
        viewModel.selectedCellData = selectedCellData
    }
}


extension NewsListView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffset = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if contentOffset > contentHeight - frameHeight - 100, !viewModel.isLoading {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.viewModel.loadNextPage()
            }
        }
    }
}

private extension NewsListView {
    
    func setupBindings() {
        searchTextField.textPublisher
            .assign(to: \.textFieldWord, on: viewModel)
            .store(in: &subscriptions)
    }
    
    @objc
    func sortByPublishedDateTapped() {
        viewModel.buttonTapped.send(.byPublishedData)
    }
    
    @objc
    func sortByPopularityTapped() {
        viewModel.buttonTapped.send(.byPopularity)
    }
    
    func setupView() {
        addSubview(searchTextField)
        addSubview(newsListTableView)
        addSubview(sortByDateButton)
        addSubview(sortByPopularityButton)
        addSubview(newsLoader)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            searchTextField.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            searchTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            searchTextField.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        NSLayoutConstraint.activate([
            sortByDateButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor, constant: -12),
            sortByDateButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 16),
            sortByDateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            sortByPopularityButton.centerYAnchor.constraint(equalTo: searchTextField.centerYAnchor, constant: 16),
            sortByPopularityButton.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 16),
            sortByPopularityButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            newsListTableView.topAnchor.constraint(equalTo: searchTextField.bottomAnchor, constant: 16),
            newsListTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            newsListTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            newsListTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            newsLoader.centerXAnchor.constraint(equalTo: newsListTableView.centerXAnchor),
            newsLoader.centerYAnchor.constraint(equalTo: newsListTableView.centerYAnchor)
        ])
    }
}
