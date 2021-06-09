//
//  DotLabel.swift
//  Guidomia
//
//  Created by Roman Bozhenko on 05.06.2021.
//

import UIKit

@IBDesignable
final class DotLabel: UILabel {
    @IBInspectable
    var textOffset: CGFloat = 30
    
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect)
        let dotLayer = getOrangeDotLayer()
        dotLayer.frame.origin.y = bounds.midY - dotLayer.frame.size.height / 3
        dotLayer.frame.origin.x = -(textOffset / 2 + dotLayer.frame.width / 2)
        layer.addSublayer(dotLayer)
    }
    
    private func getOrangeDotLayer() -> CALayer {
        let layer = CALayer()
        let dotSize = 8
        layer.frame.size = CGSize(width: dotSize, height: dotSize)
        layer.cornerRadius = layer.frame.height / 2
        layer.backgroundColor = UIColor(hex: "#FC6016").cgColor
        return layer
    }
}
