//
//  SWComboxTitleView.swift
//  AuntFood
//
//  Created by shouwei on 3/8/15.
//  Copyright (c) 2015 shou. All rights reserved.
//

import UIKit

class SWComboxTitle: UIView {

    @IBOutlet weak var name: UILabel!

    func bindTitle(title: AnyObject)
    {
        name.text = title as? String
    }

}
