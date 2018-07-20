//
//  ViewController.swift
//  SWCombox
//
//  Created by shou wei on 10/8/15.
//  Copyright (c) 2015 shou wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SWComboxViewDelegate {

    @IBOutlet weak var containner1: UIView!
    
    @IBOutlet weak var containner2: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCombox()
        setupCombox2()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func setupCombox()
    {
        var helper: SWComboxTitleHelper
        helper = SWComboxTitleHelper()
        
        let list = ["good", "middle", "bad"]
        var comboxView:SWComboxView
        comboxView = SWComboxView.loadInstanceFromNibNamedToContainner(self.containner1)! as! SWComboxView
        comboxView.bindData(data: list as NSArray, comboxHelper: helper, seletedIndex: 1, comboxDelegate: self, containnerView: self.view)
    }
    
    func setupCombox2(){
        let helper = SWComboxCountryHelper()
        
        let country1 = SWCountry()
        country1.name = "China"
        country1.image = UIImage(named: "square-CN.png")
        
        let country2 = SWCountry()
        country2.name = "Japen"
        country2.image = UIImage(named: "square-JP.png")
        
        let country3 = SWCountry()
        country3.name = "America"
        country3.image = UIImage(named: "square-US.png")
        
        let list = [country1, country2, country3]
        
        
        
        var comboxView:SWComboxView
        comboxView = SWComboxView.loadInstanceFromNibNamedToContainner(self.containner2)! as! SWComboxView//(container: self.containner2)!
        comboxView.bindData(data: list as NSArray, comboxHelper: helper, seletedIndex: 1, comboxDelegate: self, containnerView: self.view)
    }
    
    
    
    //MARK: delegate
    func selectedAtIndex(index:Int, combox withCombox: SWComboxView) {}

    func tapComboxToOpenTable(combox: SWComboxView) {}

}

