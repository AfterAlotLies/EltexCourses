//
//  CalculatorCollectionViewCell.swift
//  HomeWork#3
//
//  Created by Vyacheslav Gusev on 11.10.2024.
//

import UIKit

class CalculatorCollectionViewCell: UICollectionViewCell {
    
    static let identifer = String(describing: CalculatorCollectionViewCell.self)
    
    private lazy var calculateButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(setActionHandler), for: .touchUpInside)
        return button
    }()
    
    private var actionHandlerButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupItem()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupActionHandler(closure: (() -> Void)?) {
        actionHandlerButton = closure
    }
    
    func configureCell(symbol: String) {
        let font = UIFont.boldSystemFont(ofSize: 30)
        let attributes = [NSAttributedString.Key.font: font]
        let attributedQuote = NSAttributedString(string: symbol, attributes: attributes as [NSAttributedString.Key : Any])
        calculateButton.setAttributedTitle(attributedQuote, for: .normal)
        
        switch symbol {

        case "AC", "+/-", "%":
            calculateButton.backgroundColor = .lightGray
            calculateButton.setTitleColor(.black, for: .normal)
        case "0"..."9", ".":
            calculateButton.backgroundColor = .gray
            calculateButton.setTitleColor(.white, for: .normal)
        default:
            calculateButton.backgroundColor = .orange
            calculateButton.setTitleColor(.white, for: .normal)
        }
    }
    
}

private extension CalculatorCollectionViewCell {
    
    func setupItem() {
        contentView.addSubview(calculateButton)
        
        setupItemConstraints()
        setupCellProperties()
    }
    
    func setupCellProperties() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.clear.cgColor
        layer.cornerRadius = self.frame.height / 2
        layer.masksToBounds = true
    }
    
    func setupItemConstraints() {
        NSLayoutConstraint.activate([
            calculateButton.topAnchor.constraint(equalTo: self.topAnchor),
            calculateButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            calculateButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            calculateButton.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
    
    @objc
    func setActionHandler() {
        actionHandlerButton?()
    }
}
