//
//  GradientView.swift
//  Plantipy
//
//  Created by Egehan Karaköse on 2.05.2020.
//  Copyright © 2020 Egehan Karaköse. All rights reserved.
//

import UIKit


@IBDesignable
class GradientView: UIView {

    @IBInspectable var topColor:UIColor = #colorLiteral(red: 0.3764705882, green: 1, blue: 0.3019607843, alpha: 1){
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable var bottomColor:UIColor = #colorLiteral(red: 0.5333333333, green: 0.9254901961, blue: 1, alpha: 1){
           didSet {
               self.setNeedsLayout()
           }
       }
    
    override func layoutSubviews() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x:1 ,y:1)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
    }
}
