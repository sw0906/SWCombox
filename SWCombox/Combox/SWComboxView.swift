//
//  SWComboxView.swift
//  TradeHero
//
//  Created by shouwei on 3/8/15.
//  Copyright (c) 2015 TradeHero. All rights reserved.
//

import UIKit


@objc protocol SWComboxViewDelegate
{
    @objc optional func selectedAtIndex(index:Int, combox: SWComboxView)
    @objc optional func tapComboxToOpenTable(combox: SWComboxView)
}


class SWComboxView: UIView, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var delegate:SWComboxViewDelegate!
    var supView:UIView!
    
    var tableView:UITableView!
    var list = [Any]()
    var helper:SWComboxCommonHelper!
    var defaultIndex = 0
    var isOpen = false
    
    
    //MARK: action
    @IBAction func DidTapButton(sender: AnyObject) {
        tapTheCombox()
    }
    
    
    //MARK: bind
    func bindData(data: NSArray, comboxHelper: SWComboxCommonHelper, comboxDelegate:SWComboxViewDelegate)
    {
        bindData(data: data, comboxHelper: comboxHelper, seletedIndex: 0, comboxDelegate: comboxDelegate)
    }
    
    func bindData(data: NSArray, comboxHelper: SWComboxCommonHelper, seletedIndex: Int, comboxDelegate:SWComboxViewDelegate)
    {
        let containnerView = comboxDelegate as! UIView
        bindData(data: data, comboxHelper: comboxHelper, seletedIndex: seletedIndex, comboxDelegate: comboxDelegate, containnerView: containnerView)
    }
    
    func bindData(data: NSArray, comboxHelper: SWComboxCommonHelper, seletedIndex: Int, comboxDelegate:SWComboxViewDelegate, containnerView: UIView)
    {
        defaultIndex = seletedIndex
        delegate = comboxDelegate
        list = data as! [Any]
        helper = comboxHelper
        supView = containnerView
        setupContentView()
    }
    
    
    //MARK: interface
    func show(isShow: Bool)
    {
        self.isHidden = !isShow
        tableView?.isHidden = !isShow
    }
    func preSelectWithObject(data: AnyObject)
    {
        self.helper.setCurrentView(data: data)
    }
    func getCurrentValue() -> String
    {
        return helper.getCurrentTitle()
    }
    
    
    //MARK: setup
    private func setupContentView()
    {
        print("total count is \(list.count)")
        if defaultIndex < list.count
        {
            self.helper.loadCurrentView(contentView: contentView, data: list[defaultIndex] as AnyObject)
        }
        else
        {
            self.helper.loadCurrentView(contentView: contentView, data: list[0] as AnyObject)
        }
        self.addFrame()
    }
    
    private func setupTable()
    {
        if tableView == nil
        {
            let rect = getTableOriginFrame()//CGRectMake(orginX, orginY, self.frame.size.width, 0)
            tableView = UITableView(frame: rect, style: UITableViewStyle.plain)
            tableView.separatorStyle = UITableViewCellSeparatorStyle.none
            tableView.delegate = self
            tableView.dataSource = self
            tableView.layer.borderWidth = 0.5;
            tableView.layer.borderColor = UIColor.lightGray.cgColor;
            supView.addSubview(tableView)
        }
    }
    
    
    //MARK: table delegate/data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.frame.size.height
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table frame is \(self.tableView.frame)\n")
        let cell = helper.getCurrentCell(tableView: self.tableView, data: list[indexPath.row] as AnyObject)
        cell.addBottomLine(margin: 0, color: UIColor.lightGray)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        defaultIndex = indexPath.row
        dismissCombox()
    }
    
    
    //MARK: reload
    private func reloadData()
    {
        tableView.reloadData()
        
    }
    
    private func reloadViewWithIndex(_ index: Int)
    {
        defaultIndex = index
        let object: AnyObject = list[defaultIndex] as AnyObject
        self.helper.setCurrentView(data: object)
    }
    
    
    //MARK: Tap Action
    private func tapTheCombox()
    {
        setupTable()
        closeOtherCombox()
        closeCurrentCombox()
        openCurrentCombox()
        
        self.delegate.tapComboxToOpenTable?(combox: self)
    }
    
    
    //MARK: helper
    private func dismissCombox()
    {
        reloadViewWithIndex(defaultIndex)
        tapTheCombox()
        delegate.selectedAtIndex?(index: defaultIndex, combox: self)
    }
    
    
    private func closeOtherCombox()
    {
        closeSubCombox(subV: supView)
    }
    
    private func closeSubCombox(subV: UIView)
    {
        if (subV.isKind(of:SWComboxView.self)) && (subV as! SWComboxView != self) {
            (subV as! SWComboxView).closeCurrentCombox()
        } else {
            let childViews:[AnyObject] = subV.subviews
            if !childViews.isEmpty
            {
                for childV in childViews
                {
                    closeSubCombox(subV: childV as! UIView)
                }
            }
        }
    }
    
    private func closeCurrentCombox()
    {
        if self.isOpen
        {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                var frame = self.tableView.frame
                frame.size.height = 0
                self.tableView.frame = frame
            })
            
            UIView.animate(withDuration: 0.3,
                animations: { () -> Void in
                    var frame = self.tableView.frame
                    frame.size.height = 0
                    self.tableView.frame = frame
                },
                completion: { finished in
                    self.tableView.removeFromSuperview()
                    self.isOpen = false
                    self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)//CGAffineTransformRotate(self.arrow.transform,   CGFloat.pi)
            })
        }
    }
    
    private func openCurrentCombox()
    {
        if !self.isOpen
        {
            UIView.animate(withDuration: 0.3, animations: { () -> Void in
                if self.list.count > 0
                {
                    self.tableView.scrollToRow(at: NSIndexPath(row: 0, section: 0) as IndexPath, at: UITableViewScrollPosition.top, animated: true)
                }
                self.supView.addSubview(self.tableView)
                self.supView.bringSubview(toFront: self.tableView)
                self.tableView.frame = self.getTableFrame()
                }, completion: { finished in
                    self.isOpen = true
                    self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)// CGAffineTransform.rotated(CGAffineTransform(rotationAngle: CGFloat.pi))//rotated(CGAffineTransform(rotationAngle: <#T##CGFloat#>))//rotate(self.arrow.transform, CGFloat(Float.pi))
            })
        }
    }
    
    //table frame
    private func getTableOriginFrame() -> CGRect
    {
        var orginY = self.frame.size.height
        var orginX:CGFloat = 0
        
        var supviewR = self.superview
        var endFlag = true
        while(supviewR != nil && endFlag)
        {
            orginY += supviewR!.frame.origin.y
            orginX += supviewR!.frame.origin.x
            if (supviewR == self.supView)
            {
                endFlag = false
            }
            supviewR = supviewR?.superview
        }
        return CGRect(x:orginX, y:orginY, width:self.frame.size.width, height: 0)
    }
    
    private func getTableFrame() -> CGRect
    {
        var frame  = tableView.frame
        let countNumber = self.list.count > 4 ? 4.5 : CGFloat(self.list.count)
        frame.size.height = self.contentView.frame.height * countNumber
        let fullHeight = UIScreen.main.bounds.size.height
        if frame.origin.y + frame.size.height > fullHeight {
            frame.size.height = fullHeight - frame.origin.y
        }
        return frame
    }
}
