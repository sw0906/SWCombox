//
//  SWComboxCountryView.swift
//  AuntFood
//
//  Created by shouwei on 3/8/15.
//  Copyright (c) 2015 shou. All rights reserved.
//

import UIKit

class SWCountry:NSObject {
    var name:String!
    var image:UIImage!
}


class SWComboxCountry: UIView {
    
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    func bindCountry(country: SWCountry)
    {
        //bindImage(image: image, title: country.name)
        bindImage(country.image, title: country.name)
    }
    
    func bindImage(image:UIImage, title: String)
    {
        icon.image = image
        name.text = title
    }
}
