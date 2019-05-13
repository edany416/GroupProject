//
//  RoundedButton.swift
//  Roomies
//
//  Created by edan yachdav on 5/13/19.
//  Copyright © 2019 Roomies codepath. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    var outlineColor: UIColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        self.layer.cornerRadius = self.bounds.height/2
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        self.clipsToBounds = true
    }
    
    

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        outlineColor.setStroke()

        var straightBorderPath = UIBezierPath()
        straightBorderPath.lineWidth = 5.0
        var startPoint = CGPoint(x: self.bounds.height/2, y: 0)
        straightBorderPath.move(to: startPoint)
        var endPoint = CGPoint(x: self.bounds.width - self.bounds.height/2, y: 0)
        straightBorderPath.addLine(to: endPoint)
        straightBorderPath.stroke()
        
        var centerPoint = CGPoint(x: self.bounds.width - self.bounds.height/2, y: self.bounds.height/2)
        var semiCirclePath = UIBezierPath()
        semiCirclePath.lineWidth = 5.0
        semiCirclePath.addArc(withCenter: centerPoint,
                       radius: self.bounds.height/2,
                       startAngle: 3*CGFloat.pi/2,
                       endAngle: CGFloat.pi/2,
                       clockwise: true)
        semiCirclePath.stroke()
        
        startPoint = CGPoint(x: self.bounds.width - self.bounds.height/2, y: self.bounds.maxY)
        endPoint = CGPoint(x: self.bounds.height/2, y: self.bounds.maxY)
        straightBorderPath.move(to: startPoint)
        straightBorderPath.addLine(to: endPoint)
        straightBorderPath.stroke()
        
        centerPoint = CGPoint(x: self.bounds.height/2, y: self.bounds.height/2)
        semiCirclePath.addArc(withCenter: centerPoint,
                              radius: self.bounds.height/2,
                              startAngle: CGFloat.pi/2,
                              endAngle: 3*CGFloat.pi/2,
                              clockwise: true)
        semiCirclePath.stroke()
        
        
        
        
        
    }
    

}
