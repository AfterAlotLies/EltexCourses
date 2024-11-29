//
//  MediaUploadView.swift
//  HomeWork#9
//
//  Created by Vyacheslav Gusev on 29.11.2024.
//

import UIKit

final class MediaUploadView: UIView {
    
    private lazy var uploadedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isHidden = true
        return imageView
    }()
    
    private lazy var imageLoader: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.isHidden = true
        return indicator
    }()
    
    private lazy var loaderImageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
    private lazy var inputUrlToDownloadTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your url to download image.."
        return textField
    }()
    
    private lazy var getImageFromGalleryButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Загрузить с галереи", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    private lazy var getImageFromNetButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Загрузить с интернета", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(getImageFromURLTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var sendImageToServerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Отправить на сервер", for: .normal)
        button.layer.cornerRadius = 10
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        return button
    }()
    
    private let viewModel: MediaUploadViewModel
    
    init(frame: CGRect, viewModel: MediaUploadViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setIdleState() {
        imageLoader.stopAnimating()
        imageLoader.isHidden = true
        uploadedImageView.isHidden = true
        loaderImageLabel.isHidden = true
    }
    
    func setLoadingState() {
        uploadedImageView.isHidden = true
        imageLoader.isHidden = false
        imageLoader.startAnimating()
        loaderImageLabel.isHidden = false
        loaderImageLabel.text = "Загрузка изображения из сети..."
    }
    
    func setReadyState() {
        uploadedImageView.isHidden = false
        imageLoader.isHidden = true
        imageLoader.stopAnimating()
        loaderImageLabel.isHidden = true
    }
    
    func setImage(with data: Data) {
        uploadedImageView.image = UIImage(data: data)
    }
    
    func setOptimizingState() {
        loaderImageLabel.text = "Оптимизация картинки"
    }
}

private extension MediaUploadView {
    
    @objc
    func getImageFromURLTapped() {
        guard let imageURL = inputUrlToDownloadTextField.text, !imageURL.isEmpty else { return }
        viewModel.getImageBaseOnURL(imageURL)
        inputUrlToDownloadTextField.text = ""
    }
    
    func setupView() {
        addSubview(uploadedImageView)
        addSubview(imageLoader)
        addSubview(inputUrlToDownloadTextField)
        addSubview(getImageFromGalleryButton)
        addSubview(getImageFromNetButton)
        addSubview(sendImageToServerButton)
        addSubview(loaderImageLabel)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            uploadedImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            uploadedImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            uploadedImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            imageLoader.centerXAnchor.constraint(equalTo: uploadedImageView.centerXAnchor),
            imageLoader.centerYAnchor.constraint(equalTo: uploadedImageView.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loaderImageLabel.topAnchor.constraint(equalTo: imageLoader.bottomAnchor, constant: 6),
            loaderImageLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            loaderImageLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            inputUrlToDownloadTextField.topAnchor.constraint(equalTo: uploadedImageView.bottomAnchor, constant: 16),
            inputUrlToDownloadTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            inputUrlToDownloadTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            inputUrlToDownloadTextField.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            getImageFromGalleryButton.topAnchor.constraint(equalTo: inputUrlToDownloadTextField.bottomAnchor, constant: 16),
            getImageFromGalleryButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            getImageFromGalleryButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            getImageFromGalleryButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            getImageFromNetButton.topAnchor.constraint(equalTo: getImageFromGalleryButton.bottomAnchor, constant: 16),
            getImageFromNetButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            getImageFromNetButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            getImageFromNetButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
        NSLayoutConstraint.activate([
            sendImageToServerButton.topAnchor.constraint(equalTo: getImageFromNetButton.bottomAnchor, constant: 16),
            sendImageToServerButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            sendImageToServerButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            sendImageToServerButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -16),
            sendImageToServerButton.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
}
