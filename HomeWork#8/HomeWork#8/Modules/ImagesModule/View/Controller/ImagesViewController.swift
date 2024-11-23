//
//  ImagesViewController.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 19.11.2024.
//

import UIKit

class ImagesViewController: UIViewController {
    
    private lazy var imagesView: ImagesView = {
        let view = ImagesView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

}

private extension ImagesViewController {
    
    func setupController() {
        view.backgroundColor = .white
        view.addSubview(imagesView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imagesView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            imagesView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            imagesView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
}

