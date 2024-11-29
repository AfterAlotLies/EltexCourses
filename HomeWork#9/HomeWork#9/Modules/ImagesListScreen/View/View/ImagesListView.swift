//
//  ImagesListView.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 27.11.2024.
//

import UIKit

final class ImagesListView: UIView {
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 2
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCollectionCell.self, forCellWithReuseIdentifier: ImageCollectionCell.identifier)
        return collectionView
    }()
    
    private lazy var showNextScreenButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Добавить изображение на сервер", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(showNextControllerButtonHandler), for: .touchUpInside)
        return button
    }()
    
    private let viewModel: ImagesListViewModel
    private let imageCellViewModel: ImageCellViewModel
    private var images: [ImagesListModel]?
    
    init(frame: CGRect, viewModel: ImagesListViewModel, imageCellViewModel: ImageCellViewModel) {
        self.viewModel = viewModel
        self.imageCellViewModel = imageCellViewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getImagesSize(imagesData: [ImagesListModel]) {
        images = imagesData
        imagesCollectionView.reloadData()
    }
}

extension ImagesListView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let imagesSize = images else { return 0 }
        return imagesSize.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionCell.identifier, for: indexPath) as? ImageCollectionCell,
        let imagesModel = images else {
            return UICollectionViewCell()
        }
        let imageUrl = imagesModel[indexPath.item].url
        imageCellViewModel.configureVm(with: imageUrl)
        cell.viewModel = imageCellViewModel
        cell.configure(imageUrl)
        return cell
    }
}

extension ImagesListView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.item)
    }
}

private extension ImagesListView {
    
    @objc
    func showNextControllerButtonHandler() {
        viewModel.buttonDidTapped()
    }
    
    func setupView() {
        addSubview(imagesCollectionView)
        addSubview(showNextScreenButton)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imagesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            showNextScreenButton.topAnchor.constraint(equalTo: imagesCollectionView.bottomAnchor, constant: 16),
            showNextScreenButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            showNextScreenButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            showNextScreenButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            showNextScreenButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}
