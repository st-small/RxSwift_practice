//
//  TextView.swift
//  RxBindUI
//
//  Created by Stanly Shiyanovskiy on 06.06.18.
//  Copyright © 2018 Stanly Shiyanovskiy. All rights reserved.
//

import UIKit

class TextView: UITextView {
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }
    
    func configure() {
        layer.cornerRadius = 5.0
        layer.borderWidth = 0.5
        layer.borderColor = UIColor(red: 204/255.0, green: 204/255.0, blue: 204/255.0, alpha: 1.0).cgColor
    }
    
}
