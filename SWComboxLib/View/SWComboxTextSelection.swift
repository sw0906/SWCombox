//
//  SWComboxTitleView.swift
//  AuntFood
//
//  Created by shouwei on 3/8/15.
//  Copyright (c) 2015 shou. All rights reserved.
//

import UIKit


struct SWComboxTitleNibResourceType: NibResourceType {
    let bundle = Bundle(for: SWComboxTextSelection.self)
    let name = "SWComboxTextSelection"
}

open class SWComboBox: NibView {
    public func bind(_ data: Any) {}
    public var title: String { return "" }
}

open class SWComboxTextSelection: SWComboBox {

    @IBOutlet public var container: UIView!

    @IBOutlet public weak var name: UILabel!

    override open var title : String {
        return name.text ?? ""
    }

    override open func commonInit() {
        let nibType = SWComboxTitleNibResourceType()
        _ = nibType.firstView(owner: self)
        addSubviewToMaxmiumSize(view: self.container)
    }

    override open func bind(_ data: Any) {
        name.text = data as? String
    }
}
