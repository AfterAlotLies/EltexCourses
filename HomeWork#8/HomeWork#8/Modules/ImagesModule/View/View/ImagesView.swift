//
//  ImagesView.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 21.11.2024.
//

import UIKit

final class ImagesView: UIView {
    
    private lazy var imagesCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.register(ImagesCell.self, forCellWithReuseIdentifier: ImagesCell.identifier)
        return collectionView
    }()
    
    private lazy var uiimageview: UIImageView = {
        let imageview = DownloadableImageView()
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private let imagesURLs: [String] = [
        "https://www.cnet.com/a/img/resize/763a63f8451291f93958420b4b9fc2ba69ed57e5/hub/2024/11/19/dbd88023-5beb-4cd8-95f1-12bc6ca43740/screenshot-2024-11-19-at-1-32-56pm.png?auto=webp&fit=crop&height=675&width=1200",
        "https://media.wired.com/photos/66ea077283cd4f2fbb17d478/191:100/w_1280,c_limit/WIRED-Coupons-2.jpg",
        "https://images.macrumors.com/t/u419F9T-2zXWL5Hkvaw4AqK7ZBg=/2500x/article-new/2024/10/Generic-iOS-18.2-Feature-Real-Mock.jpg",
        "https://www.cnet.com/a/img/resize/5e32652c9083dc1d09521e0787fe58eb604b81a7/hub/2024/09/17/7f399551-e39c-46a9-b6f5-ee2efae5e89a/apple-iphone-16-pro-max-camera-lens-photography-4742.jpg?auto=webp&fit=crop&height=675&width=1200",
        "https://www.cnet.com/a/img/resize/fa85b07ee746dc2d7be10cf243f0d5d1ecb3666e/hub/2024/11/15/01b6bcaa-e7cb-4066-8d10-167cb790dfe2/survey.jpg?auto=webp&fit=crop&height=675&width=1200",
        "https://i.insider.com/673dd3a4ede4eeae39288ee5?width=1200&format=jpeg",
        "https://www.cnet.com/a/img/resize/c44672906aee2a0bfaf39bba01791b7bf5a33572/hub/2024/11/20/fc18aa42-005a-4254-9467-4d57d4957cf4/magsafe-black-friday.png?auto=webp&fit=crop&height=675&width=1200",
    ]
    
    private let viewModel: ImagesViewModel
    
    init(frame: CGRect, viewModel: ImagesViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ImagesView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.countOfImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImagesCell.identifier, for: indexPath) as? ImagesCell else {
            return UICollectionViewCell()
        }
        
        let cellData = viewModel.getImageURL(at: indexPath.item)
        cell.configureImage(for: cellData)
        return cell
    }
}

private extension ImagesView {
    
    func setupView() {
        addSubview(imagesCollectionView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imagesCollectionView.topAnchor.constraint(equalTo: self.topAnchor),
            imagesCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imagesCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imagesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
