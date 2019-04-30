//
//  CircleButton.swift
//  Roomies
//
//  Created by Louise F Jensen on 4/30/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

class CircleButton: UIButton {

    var circleStrokeColor: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func draw(_ rect: CGRect) {
        circleStrokeColor.setStroke()
        let minDimension = (rect.height <= rect.width) ? rect.height : rect.width
        let circlePath = UIBezierPath()
        circlePath.lineWidth = 1
        circlePath.addArc(withCenter: centerPoint(), radius: minDimension/2.2, startAngle: 0, endAngle: CGFloat.pi*2, clockwise: true)
        circlePath.stroke()
    }
    
    private func centerPoint() -> CGPoint {
        let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
        return center
    }
   

}
