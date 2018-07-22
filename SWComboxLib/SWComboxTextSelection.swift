//
//  SWComboxTitleView.swift
//  Created by shouwei on 3/8/15.
//  Copyright (c) 2015 shou. All rights reserved.
//

import UIKit


struct SWComboxTitleNibResourceType: NibResourceType {
    let bundle = Bundle(for: SWComboxTextSelection.self)
    let name = "SWComboxTextSelection"
}

public protocol SWComboBoxContent {
    func bind(_ data: Any)
//    var title: String { get}
}

open class SWComboxTextSelection: SWComboxSelectionView {

    @IBOutlet public var container: UIView!

    @IBOutlet public weak var name: UILabel!

    override open func commonInit() {
        let nibType = SWComboxTitleNibResourceType()
        _ = nibType.firstView(owner: self)
        addSubviewToMaxmiumSize(view: self.container)

        self.backgroundColor = UIColor.clear
        self.container.backgroundColor = UIColor.clear
    }

    override open func bind(_ data: Any) {
        name.text = data as? String
    }
}
