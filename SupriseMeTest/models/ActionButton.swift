//
//  ActionButton.swift
//  SupriseMeTest
//
//  Created by Владислав Дьяков on 12.07.2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

class ActionButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init( coder: aDecoder )
        setUp()
    }
    
    func setUp() {
        layer.cornerRadius = 8
        addTarget(self, action: #selector(pressAnimation), for: .touchUpInside)
    }
    
    @objc func pressAnimation() {
        
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.15
        pulse.fromValue = 1.0
        pulse.toValue = 0.95
        pulse.autoreverses = true
        pulse.repeatCount = 0
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        
        let animation = CABasicAnimation(keyPath: "opacity")
        animation.duration = 0.15
        animation.fromValue = 1
        animation.toValue = 0.7
        animation.repeatCount = 0
        animation.autoreverses = true
        
        layer.add(pulse, forKey: "pulse")
        layer.add(animation, forKey: "opacity")
    }
}

class LinkLabel: UILabel {
    // заглушка
}
