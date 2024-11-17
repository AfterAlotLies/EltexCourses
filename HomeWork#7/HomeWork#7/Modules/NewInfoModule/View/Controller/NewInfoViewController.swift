//
//  NewInfoViewController.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 15.11.2024.
//

import UIKit
import Combine

final class NewInfoViewController: UIViewController {
    
    private lazy var newInfo: NewInfoView = {
        let view = NewInfoView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: NewInfoViewModel
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
    
    init(viewModel: NewInfoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension NewInfoViewController {
    
    func setupBindings() {
        viewModel.$selectedCellData
            .sink { [weak self] cellData in
                if let cellData = cellData {
                    self?.newInfo.configurateView(with: NewInfoModel(title: cellData.title,
                                                                     dataPublished: cellData.dataPublished,
                                                                     author: cellData.author ?? "",
                                                                     content: cellData.content))
                }
            }
            .store(in: &subscriptions)
    }
    
    func setupController() {
        view.addSubview(newInfo)
        view.backgroundColor = .white

        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            newInfo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newInfo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            newInfo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            newInfo.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}
