//
//  NewInfoView.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 15.11.2024.
//

import UIKit

final class NewInfoView: UIView {
    
    private lazy var newTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var newDateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var newAuthorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var newDescriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = ""
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 22)
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configurateView(with newInfo: NewInfoModel) {
        newTitleLabel.text = newInfo.title
        newDateLabel.text = "Дата публикации: \(newInfo.dataPublished)"
        if newInfo.author == "" {
            newAuthorLabel.text = "Нет автора новости"
        } else {
            newAuthorLabel.text = "Автор новости: \(newInfo.author)"
        }
        newDescriptionTextView.text = newInfo.content
    }
}

private extension NewInfoView {
    
    func setupView() {
        addSubview(newTitleLabel)
        addSubview(newDateLabel)
        addSubview(newAuthorLabel)
        addSubview(newDescriptionTextView)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            newTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16),
            newTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            newTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            newDateLabel.topAnchor.constraint(equalTo: newTitleLabel.bottomAnchor, constant: 16),
            newDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            newDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            newAuthorLabel.topAnchor.constraint(equalTo: newDateLabel.bottomAnchor, constant: 16),
            newAuthorLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            newAuthorLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            newDescriptionTextView.topAnchor.constraint(equalTo: newAuthorLabel.bottomAnchor, constant: 16),
            newDescriptionTextView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            newDescriptionTextView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            newDescriptionTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
