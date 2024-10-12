//
//  MainViewController.swift
//  HomeWork#3
//
//  Created by Vyacheslav Gusev on 11.10.2024.
//

import UIKit

class MainViewController: UIViewController {
    
    private let viewModel = CalculatorViewModel()
    
    private lazy var mainView: MainView = {
        let view = MainView(frame: .zero, viewModel: viewModel)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

private extension MainViewController {
    
    func setupView() {
        view.backgroundColor = .black
        
        view.addSubview(mainView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

