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
        containner1.dataSource = self
        containner1.delegate = self
        containner1.showMaxCount = 4
        containner1.defaultSelectedIndex = 1 //start from 0

        containner2.dataSource = self
        containner2.delegate = self
    }

}

extension ViewController: SWComboxViewDataSourcce {
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        if combox == containner1 {
            return ["good", "middle", "bad", "good", "middle", "bad", "good", "middle", "bad","good", "middle", "bad"]
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

    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        if combox == containner1 {
            return SWComboxTextSelection()
        }
        return SWComboxImageSelection()
    }

    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
        if combox == containner1 {
            cell.selectionStyle = .none
            cell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
        }
    }
}

extension ViewController : SWComboxViewDelegate {
    //MARK: delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        print("index - \(index) selected - \(object)")
    }

    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
        if isOpen {
            if combox == containner1 && containner2.isOpen {
                containner2.onAndOffSelection()
            }

            if combox == containner2 && containner1.isOpen {
                containner1.onAndOffSelection()
            }
        }
    }


}

