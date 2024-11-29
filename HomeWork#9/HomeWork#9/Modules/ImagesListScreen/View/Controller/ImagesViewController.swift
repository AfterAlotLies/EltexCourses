//
//  ImagesViewController.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 27.11.2024.
//

import UIKit
import Combine

class ImagesViewController: UIViewController {
    
    private lazy var imagesListView: ImagesListView = {
        let view = ImagesListView(frame: .zero, viewModel: viewModel, imageCellViewModel: imageCellViewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: ImagesListViewModel
    private let imageCellViewModel: ImageCellViewModel
    private var subscriptions: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllImagesData()
    }
    
    init(viewModel: ImagesListViewModel, imageCellViewModel: ImageCellViewModel) {
        self.viewModel = viewModel
        self.imageCellViewModel = imageCellViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ImagesViewController {
    
    func setupBindings() {
        viewModel.$images
            .sink { images in
                self.imagesListView.getImagesSize(imagesData: images)
            }
            .store(in: &subscriptions)
    }
    
    func setupController() {
        view.backgroundColor = .white
        
        view.addSubview(imagesListView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesListView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagesListView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imagesListView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imagesListView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

