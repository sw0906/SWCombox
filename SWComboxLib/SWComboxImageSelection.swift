//
//  SWComboxCountryView.swift
//  AuntFood
//
//  Created by shouwei on 3/8/15.
//  Copyright (c) 2015 shou. All rights reserved.
//

import UIKit

open class SWImageSelection:NSObject {
    public var name:String!
    public var image:UIImage!
}

struct SWComboxCountryNibResourceType: NibResourceType {
    let bundle = Bundle(for: SWComboxImageSelection.self)
    let name = "SWComboxImageSelection"
}

open class SWComboxImageSelection: SWComboxSelectionView {
    
    @IBOutlet public var container: UIView!

    @IBOutlet public weak var icon: UIImageView!
    
    @IBOutlet public weak var name: UILabel!

    override open func commonInit() {
        let nibType = SWComboxCountryNibResourceType()
        _ = nibType.firstView(owner: self)
        addSubviewToMaxmiumSize(view: self.container)
        self.backgroundColor = UIColor.clear
        self.container.backgroundColor = UIColor.clear
    }

    override open func bind(_ data: Any) {
        guard let data = data as? SWImageSelection else {
            return
        }
        bindImage(image: data.image, title: data.name)
    }
    
    open func bindImage(image:UIImage, title: String)
    {
        icon.image = image
        name.text = title
    }
}
