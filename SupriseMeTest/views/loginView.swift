//
//  loginView.swift
//  SupriseMeTest
//
//  Created by Владислав Дьяков on 15.07.2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

class loginView: UIView {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    private func setup() {
        fromNib()
        clipsToBounds = true
        layer.cornerRadius = 24
    }
}

