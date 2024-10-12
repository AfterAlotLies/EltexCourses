//
//  MainView.swift
//  HomeWork#3
//
//  Created by Vyacheslav Gusev on 11.10.2024.
//

import Foundation
import UIKit

class MainView: UIView {
        
    private lazy var calculatorInputLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .right
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 50)
        label.text = "0"
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var calculatorCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(CalculatorCollectionViewCell.self,
                                forCellWithReuseIdentifier: CalculatorCollectionViewCell.identifer)
        collectionView.backgroundColor = .clear
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    private let buttonsData: [String] = ["AC", "+/-", "%", "÷", "7", "8", "9", "×", "4", "5", "6", "-", "1", "2", "3", "+", "0", ".", "="]
    
    private let viewModel: CalculatorViewModel
    
    init(frame: CGRect, viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        setupView()
        bindViewModel()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension MainView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfItemsPerRow: CGFloat = 4
        let spacingBetweenItems: CGFloat = 10
        let totalSpacing = (numberOfItemsPerRow - 1) * spacingBetweenItems
        let width = (collectionView.bounds.width - totalSpacing) / numberOfItemsPerRow
        
        if indexPath.item == 16 {
            return CGSize(width: width * 2 + spacingBetweenItems, height: collectionView.frame.height / 5 - 10)
        } else {
            return CGSize(width: width, height: collectionView.frame.height / 5 - 10)
        }
    }
    
}

extension MainView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttonsData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalculatorCollectionViewCell.identifer, for: indexPath) as? CalculatorCollectionViewCell else {
            return UICollectionViewCell()
        }
        let buttonSymbol = buttonsData[indexPath.row]
        cell.configureCell(symbol: buttonSymbol)
        
        cell.setupActionHandler { [weak self] in
            self?.viewModel.didTappedButton(with: buttonSymbol)
        }
        
        return cell
    }
    
}

private extension MainView {
    
    func setupView() {
        addSubview(calculatorInputLabel)
        addSubview(calculatorCollectionView)
        backgroundColor = .clear
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            calculatorInputLabel.topAnchor.constraint(lessThanOrEqualToSystemSpacingBelow: self.topAnchor, multiplier: 26),
            calculatorInputLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 16),
            calculatorInputLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            calculatorCollectionView.topAnchor.constraint(equalTo: calculatorInputLabel.bottomAnchor, constant: 16),
            calculatorCollectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            calculatorCollectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant:  -16),
            calculatorCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8),
            calculatorCollectionView.heightAnchor.constraint(equalTo: self.calculatorCollectionView.widthAnchor, multiplier: 5.0 / 4.0)
        ])
    }
    
    func bindViewModel() {
        viewModel.bindOnUpdateDisplay { [weak self] displayText in
            guard let self = self else { return }
            self.calculatorInputLabel.text = displayText
        }
    }
}
