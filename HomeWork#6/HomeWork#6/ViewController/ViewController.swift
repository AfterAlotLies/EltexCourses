//
//  ViewController.swift
//  HomeWork#6
//
//  Created by Vyacheslav Gusev on 06.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    private lazy var collectionView: UICollectionView = {
        let layout = CollectionViewLayout()
        layout.data = collectionData
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        return collectionView
    }()
    
    private let collectionData: Data = Data(alignment: .center,
                                            elements: [[.small, .small, .normal, .small],
                                                       [.normal, .small, .normal],
                                                       [.small, .normal, .small],
                                                       [.small, .normal],
                                                       [.small, .small, .small, .small],
                                                       [.small],
                                                       [.normal, .normal],
                                                       [.normal]])

    override func viewDidLoad() {
        super.viewDidLoad()
        setupController()
    }

}

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfElements = 0
        collectionData.elements.forEach { numberOfElements += $0.count }
        return numberOfElements
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
            return UICollectionViewCell()
        }
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
}

private extension ViewController {
    
    func setupController() {
        view.addSubview(collectionView)
        view.backgroundColor = .white
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
    }
}
