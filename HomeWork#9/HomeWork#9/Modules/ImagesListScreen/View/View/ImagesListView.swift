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
    
    func setupView() {
        addSubview(imagesCollectionView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: topAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            imagesCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            imagesCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
