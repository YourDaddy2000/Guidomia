//
//  Drawer.swift
//  Guidomia_MVP
//
//  Created by Roman Bozhenko on 04.06.2021.
//

import UIKit

enum Drawer {
    private static let scaleFactor = UIScreen.main.scale
    
    static func drawMenuButtonImage() -> UIImage {
        let width = 14 * scaleFactor
        let height = 8 * scaleFactor
        let numberOfLines = 3
        let lineSpacerHeight = 1.5 * scaleFactor
        let lineHeight = (height - (lineSpacerHeight * CGFloat(numberOfLines))) / CGFloat(numberOfLines)
        let lineSize = CGSize(width: width, height: lineHeight)
        let lineTwoY: CGFloat = height / 2 - lineHeight / 2
        let lineThreeY: CGFloat = height - lineHeight
        
        let layer = CALayer()
        layer.frame.size = CGSize(width: width, height: height)
        
        let lineOneLayer = drawRect(size: lineSize, color: .white)
        let lineTwoLayer = drawRect(size: lineSize, color: .white)
        let lineThreeLayer = drawRect(size: lineSize, color: .white)
        
        lineTwoLayer.frame.origin.y = lineTwoY
        lineThreeLayer.frame.origin.y = lineThreeY
        
        layer.addSublayer(lineOneLayer)
        layer.addSublayer(lineTwoLayer)
        layer.addSublayer(lineThreeLayer)
        return imageFromLayer(layer: layer)
    }
    
    private static func drawRect(size: CGSize, color: UIColor) -> CALayer {
        let layer = CALayer()
        layer.frame.size = size
        layer.backgroundColor = color.cgColor
        layer.cornerRadius = 2
        return layer
    }
    
    static func imageFromLayer(layer: CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }
    
    static func drawNavBarBackgroundImage(height: CGFloat) -> UIImage {
        let layer = CALayer()
        let size = CGSize(
            width: UIScreen.main.bounds.width,
            height: height)
        
        layer.frame.size = size
        layer.backgroundColor = UIColor.navBarOrange.cgColor
        
        return imageFromLayer(layer: layer)
    }
}
