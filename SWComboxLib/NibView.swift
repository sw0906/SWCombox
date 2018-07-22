//
//  NibView.swift
//  SWCombox
//
//  Created by shouwei on 2018/7/21.
//  Copyright © 2018 shou wei. All rights reserved.
//

import UIKit

open class NibView: UIView {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open func commonInit() {}
}


