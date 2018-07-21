//
//  ViewController.swift
//  SWCombox
//
//  Created by shou wei on 10/8/15.
//  Copyright (c) 2015 shou wei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var containner1: SWComboxView!
    
    @IBOutlet weak var containner2: SWComboxView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCombox()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupCombox() {
        containner1.bindData(comboxDelegate: self)
        containner2.bindData(comboxDelegate: self)
    }

}

extension ViewController : SWComboxViewDelegate {

    func swComboBoxSelections(combox: SWComboxView) -> [Any] {
        if combox == containner1 {
            return ["good", "middle", "bad"]
        }
        else {
            let country1 = SWImageSelection()
            country1.name = "China"
            country1.image = #imageLiteral(resourceName: "square-CN.png")

            let country2 = SWImageSelection()
            country2.name = "Japen"
            country2.image = #imageLiteral(resourceName: "square-JP.png")

            let country3 = SWImageSelection()
            country3.name = "America"
            country3.image = #imageLiteral(resourceName: "square-US.png")

            let list = [country1, country2, country3]
            return list
        }
    }


    func swComboBox(combox: SWComboxView) -> SWComboBox {
        if combox == containner1 {
            return SWComboxTextSelection()
        }
        return SWComboxImageSelection()
    }


    //MARK: delegate
    func selectedAtIndex(index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
    }

    func tapComboBox(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            if combox == containner1 && containner2.isOpen {
                containner2.onAndOffSelection()
            }

            if combox == containner2 && containner1.isOpen {
                containner1.onAndOffSelection()
            }
        }
    }

    func configureComboBoxCell(combox: SWComboxView, cell: inout UITableViewCell) {
        if combox == containner1 {
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        }
    }
}

