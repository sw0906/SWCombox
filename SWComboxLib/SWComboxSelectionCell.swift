//
//  SWComboxSelectionCell.swift
//  SWCombox
//
//  Created by shouwei on 2018/7/22.
//  Copyright © 2018 shou wei. All rights reserved.
//

import UIKit

public class SWComboxSelectionCell: UITableViewCell {
    open var selectionView: SWComboxSelectionView?

    open func addSelectionView(_ view: SWComboxSelectionView) {
        self.contentView.addSubviewToMaxmiumSize(view: view)
        selectionView = view
    }
    open func updateData(_ data: Any) {
        selectionView?.bind(data)
    }
}
