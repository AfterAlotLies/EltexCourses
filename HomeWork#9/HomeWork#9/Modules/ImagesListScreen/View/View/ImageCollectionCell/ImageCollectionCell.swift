//
//  ImageCollectionCell.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 27.11.2024.
//

import UIKit
import Combine

final class ImageCollectionCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: ImageCollectionCell.self)
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        imageView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        return imageView
    }()
    
    private lazy var downloadImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Скачать", for: .normal)
        button.addTarget(self, action: #selector(downloadButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.isHidden = true
        return bar
    }()
    
    var viewModel: ImageCellViewModel?
    
    private var subscriptions: Set<AnyCancellable> = []
    private var imageUrl: String?
    private var isLoaded: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    func configure(_ imageUrl: String) {
        self.imageUrl = imageUrl
        setupBindingForCell()
    }
}

private extension ImageCollectionCell {
    
    func setupBindingForCell() {
        viewModel?.$imageData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] imageData in
                guard let self = self, let url = self.imageUrl else { return }
                if let data = imageData[url] {
                    isLoaded = true
                    self.downloadImageButton.isHidden = true
                    self.imageView.isHidden = false
                    if self.progressBar.progress == 1.0 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.progressBar.isHidden = true
                            self.imageView.image = UIImage(data: data)
                            self.imageView.contentMode = .scaleAspectFit
                        }
                    }
                   
                } else {
                    self.imageView.isHidden = true
                    self.downloadImageButton.isHidden = false
                }
            }
            .store(in: &subscriptions)
        
        viewModel?.$imageDataProgress
            .sink(receiveValue: { [weak self] progress in
                guard let self = self, let url = self.imageUrl else { return }
                if let progress = progress[url] {
                    if !self.isLoaded {
                        self.downloadImageButton.isHidden = true
                        self.progressBar.isHidden = false
                        self.progressBar.setProgress(progress, animated: true)
                    } else {
                        return
                    }
                } else {
                    self.progressBar.isHidden = true
                }
            })
            .store(in: &subscriptions)
    }
    
    @objc
    func downloadButtonTapped() {
        guard let imageUrl = imageUrl else { return }
        viewModel?.loadImage(from: imageUrl)
    }
    
    func setupCell() {
        contentView.addSubview(imageView)
        contentView.addSubview(downloadImageButton)
        contentView.addSubview(progressBar)
        
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            downloadImageButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            downloadImageButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            progressBar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            progressBar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            progressBar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6)
        ])
    }
}
