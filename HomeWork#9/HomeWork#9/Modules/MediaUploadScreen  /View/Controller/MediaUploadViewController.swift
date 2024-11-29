//
//  MediaUploadViewController.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 29.11.2024.
//

import UIKit
import Combine

final class MediaUploadViewController: UIViewController {
    
    private lazy var mediaUploadView: MediaUploadView = {
        let view = MediaUploadView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let viewModel: MediaUploadViewModel
    
    private var subscriptions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
        setupBindings()
    }
    
    init(viewModel: MediaUploadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension MediaUploadViewController {
    
    func setupBindings() {
        viewModel.$imageData
            .sink { imageData in
                if let image = imageData {
                    self.mediaUploadView.setReadyState()
                    self.mediaUploadView.setImage(with: image)
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$processState
            .sink { processState in
                switch processState {
                case .idle:
                    break
                case .loading:
                    self.mediaUploadView.setLoadingState()
                case .optimizing:
                    self.mediaUploadView.setOptimizingState()
                case .ready:
                    self.mediaUploadView.setReadyState()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.$requestError
            .sink { error in
                if !error.isEmpty {
                    self.mediaUploadView.setIdleState()
                    self.showErrorAlert(for: error)
                }
            }
            .store(in: &subscriptions)
        
    }
    
    func showErrorAlert(for errorMessage: String) {
        let alert = UIAlertController(title: "Something gone wrong", message: errorMessage, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    func setupController() {
        view.backgroundColor = .white
        view.addSubview(mediaUploadView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mediaUploadView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mediaUploadView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mediaUploadView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mediaUploadView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}
