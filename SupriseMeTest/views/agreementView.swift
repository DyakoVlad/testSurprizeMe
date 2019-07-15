//
//  agreementView.swift
//  SupriseMeTest
//
//  Created by Владислав Дьяков on 12.07.2019.
//  Copyright © 2019 Vlad Dyakov. All rights reserved.
//

import UIKit

class agreementView: UIView {
    
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
        layer.cornerRadius = 14
    }

}
