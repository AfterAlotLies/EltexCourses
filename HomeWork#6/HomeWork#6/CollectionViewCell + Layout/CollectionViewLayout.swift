//
//  CollectionViewLayout.swift
//  HomeWork#6
//
//  Created by Vyacheslav Gusev on 07.11.2024.
//

import UIKit

final class CollectionViewLayout: UICollectionViewLayout {
    
    private var attributesCache: [UICollectionViewLayoutAttributes] = []
    private var contentHeight: CGFloat = 0
    private let cellHeight: CGFloat = 40
    private let horizontalPadding: CGFloat = 10
    private let verticalPadding: CGFloat = 15
    private let startY: CGFloat = 20
    private var contentSize: CGSize = .zero
    
    var data: Data?

    override func prepare() {
        guard let collectionView = collectionView,
              let data = data else { return }
        
        showData(data: data)
        
        attributesCache.removeAll()
        
        var yOffset: CGFloat = startY
        var itemIndex = 0
        
        let containerWidth = collectionView.bounds.width
        
        for row in data.elements {
            var totalRowWidth: CGFloat = 0
            var cellWidths: [CGFloat] = []
            
            for cellSize in row {
                let cellWidth: CGFloat = containerWidth * CGFloat(cellSize.rawValue)
                cellWidths.append(cellWidth)
                totalRowWidth += cellWidth
            }
            
            totalRowWidth += CGFloat(row.count - 1) * horizontalPadding
            
            if totalRowWidth > containerWidth {
                //коэф сжатия для ячейки, если ячейкой выходим за границу размерности
                let scaleFactor = (containerWidth - CGFloat(row.count - 1) * horizontalPadding) / totalRowWidth
                for i in 0..<cellWidths.count {
                    cellWidths[i] *= scaleFactor
                }
            }
            
            var xOffset: CGFloat = 0
            
            switch data.alignment {
            case .left:
                xOffset = 10
            case .center:
                if totalRowWidth <= containerWidth {
                    xOffset = (containerWidth - totalRowWidth) / 2
                } else {
                    xOffset = 10
                }
            case .right:
                if totalRowWidth <= containerWidth {
                    xOffset = containerWidth - totalRowWidth - 20
                } else {
                    xOffset = 10
                }
            }

            for cellWidth in cellWidths {
                let indexPath = IndexPath(item: itemIndex, section: 0)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attributes.frame = CGRect(x: xOffset, y: yOffset, width: cellWidth, height: cellHeight)
                attributesCache.append(attributes)
                
                xOffset += cellWidth + horizontalPadding
                itemIndex += 1
            }
            
            yOffset += cellHeight + verticalPadding
        }
        
        contentHeight = yOffset
        contentSize = collectionView.bounds.size
    }


    override var collectionViewContentSize: CGSize {
        return contentSize
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesCache.filter { $0.frame.intersects(rect) }
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return attributesCache[indexPath.item]
    }
    
}

private extension CollectionViewLayout {
    
    func showData(data: Data) {
        data.elements.forEach { (value: [Size]) in
            if value.isEmpty {
                fatalError()
            }
            
            if value.reduce(0.0, { $0 + $1.rawValue }) > 1 {
                fatalError()
            }
        }
    }
}
