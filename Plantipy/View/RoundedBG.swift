//
//  RoundedBG.swift
//  Plantipy
//
//  Created by Egehan Karaköse on 1.05.2020.
//  Copyright © 2020 Egehan Karaköse. All rights reserved.
//

import UIKit


class BlackBGView: UIView{
    
    override func awakeFromNib() {
        layer.backgroundColor = BLACK_BG
        layer.cornerRadius = 10
    }
    
    
}

class WhiteBGView: UIView{
    
    override func awakeFromNib() {
        layer.backgroundColor = WHITE_BG
        layer.cornerRadius = 10
    }
    
    
    
}
class BlueRoundedBG: UIView{

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.backgroundColor = MAIN_BG
        roundCorners(corners: [.topLeft, .topRight], radius: 30.0)
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}


