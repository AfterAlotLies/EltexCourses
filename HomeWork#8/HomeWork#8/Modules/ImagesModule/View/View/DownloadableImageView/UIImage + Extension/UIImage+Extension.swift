//
//  UIImage+Extension.swift
//  HomeWork#8
//
//  Created by Vyacheslav Gusev on 22.11.2024.
//

import UIKit

extension UIImage {
    
    func resizeImage(to size: CGSize, preserveCorners: Bool = false, cornerRadius: CGFloat? = nil) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        let context = UIGraphicsGetCurrentContext()
        
        if preserveCorners, let cornerRadius = cornerRadius {
            let path = UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: cornerRadius)
            context?.addPath(path.cgPath)
            context?.clip()
        }
        
        self.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func maskRoundedImage(image: UIImage, radius: CGFloat) -> UIImage? {
        let rect = CGRect(origin: .zero, size: image.size)
        
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return nil
        }
        
        let path = UIBezierPath(roundedRect: rect, cornerRadius: radius)
        context.addPath(path.cgPath)
        context.clip()
        image.draw(in: rect)
        
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return roundedImage
    }
    
}
