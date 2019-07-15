//
//  HelpButton.swift
//  SupriseMeTest
//
//  Created by Владислав Дьяков on 13.07.2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

class HelpButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUp()
    }
    
    func setUp() {
        addTarget(self, action: #selector(pressAnimation), for: .touchUpInside)
    }
    
    @objc func pressAnimation() {
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.2
        animation.fromValue = 1
        animation.toValue = 0.2
        animation.repeatCount = 0
        animation.autoreverses = true
        
        layer.add(animation, forKey: "opacity")
    }
    
    func addShadow() {
        layer.shadowColor           = UIColor.darkGray.cgColor
        layer.shadowOpacity         = 0.18
        layer.shadowOffset          = CGSize(width: 0, height: 0)
        layer.shadowRadius          = 10
        layer.shadowPath            = UIBezierPath(rect: bounds).cgPath
        layer.cornerRadius          = 12
    }
}

