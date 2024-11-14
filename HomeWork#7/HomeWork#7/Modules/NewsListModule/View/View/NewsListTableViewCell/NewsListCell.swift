//
//  NewsListCell.swift
//  HomeWork#7
//
//  Created by Vyacheslav Gusev on 14.11.2024.
//

import UIKit

final class NewsListCell: UITableViewCell {
    
    static let identifier: String = String(describing: NewsListCell.self)
    
    private lazy var cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 10
        return view
    }()
    
    private lazy var newTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var newDataPublished: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        newTitle.text = nil
        newDataPublished.text = nil
    }
    
    func configureCell(title: String, dataPublished: String) {
        newTitle.text = title
        newDataPublished.text = dataPublished
    }
}

private extension NewsListCell {
    
    func setupCell() {
        contentView.addSubview(cellView)
        cellView.addSubview(newTitle)
        cellView.addSubview(newDataPublished)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 4),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -4),
        ])
        
        NSLayoutConstraint.activate([
            newTitle.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16),
            newTitle.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            newTitle.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -16),
            newTitle.trailingAnchor.constraint(lessThanOrEqualTo: newDataPublished.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            newDataPublished.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 16),
            newDataPublished.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16),
            newDataPublished.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -16)
        ])
        
        newDataPublished.setContentCompressionResistancePriority(.required, for: .horizontal)
    }
}
