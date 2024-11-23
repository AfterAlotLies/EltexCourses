//
//  ImagesCell.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 21.11.2024.
//

import UIKit

final class ImagesCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: ImagesCell.self)
    
    private lazy var someImageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        someImageView.image = nil
    }
    
    func configureImage(for url: String) {
        someImageView.loadImage(from: URL(string: url)!,
                                withOptions: [.resize,
                                              .cached(.memory),
                                              .circle
                                              ]
        )
    }
}

private extension ImagesCell {
    
    func setupCell() {
        contentView.addSubview(someImageView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            someImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            someImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            someImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            someImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
}
