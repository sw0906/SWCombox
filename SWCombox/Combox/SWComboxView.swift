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
    optional func selectedAtIndex(index:Int, combox: SWComboxView)
    optional func tapComboxToOpenTable(combox: SWComboxView)
}


class SWComboxView: UIView, UITableViewDataSource, UITableViewDelegate
{
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var button: UIButton!
    
    var delegate:SWComboxViewDelegate!
    var supView:UIView!
    
    var tableView:UITableView!
    var list = []
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
        bindData(data, comboxHelper: comboxHelper, seletedIndex: 0, comboxDelegate: comboxDelegate)
    }
    
    func bindData(data: NSArray, comboxHelper: SWComboxCommonHelper, seletedIndex: Int, comboxDelegate:SWComboxViewDelegate)
    {
        var containnerView = comboxDelegate as! UIView
       bindData(data, comboxHelper: comboxHelper, seletedIndex: seletedIndex, comboxDelegate: comboxDelegate, containnerView: containnerView)
    }
    
    func bindData(data: NSArray, comboxHelper: SWComboxCommonHelper, seletedIndex: Int, comboxDelegate:SWComboxViewDelegate, containnerView: UIView)
    {
        defaultIndex = seletedIndex
        delegate = comboxDelegate
        list = data
        helper = comboxHelper
        supView = containnerView
        setupContentView()
    }
    
    
    //MARK: interface
    func show(isShow: Bool)
    {
        self.hidden = !isShow
        tableView?.hidden = !isShow
    }
    func preSelectWithObject(data: AnyObject)
    {
        self.helper.setCurrentView(data)
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
            self.helper.loadCurrentView(contentView, data: list[defaultIndex])
        }
        else
        {
            self.helper.loadCurrentView(contentView, data: list[0])
        }
        self.addFrame()
    }
    
    private func setupTable()
    {
        if tableView == nil
        {
            var rect = getTableOriginFrame()//CGRectMake(orginX, orginY, self.frame.size.width, 0)
            tableView = UITableView(frame: rect, style: UITableViewStyle.Plain)
            tableView.separatorStyle = UITableViewCellSeparatorStyle.None
            tableView.delegate = self
            tableView.dataSource = self
            tableView.layer.borderWidth = 0.5;
            tableView.layer.borderColor = UIColor.lightGrayColor().CGColor;
            supView.addSubview(tableView)
        }
    }
    
    
    //MARK: table delegate/data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.frame.size.height
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print("table frame is \(self.tableView.frame)\n")
        var cell = helper.getCurrentCell(self.tableView, data: list[indexPath.row])
        cell.addBottomLine(0, color: UIColor.lightGrayColor())
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        defaultIndex = indexPath.row
        dismissCombox()
    }
    
    
    //MARK: reload
    private func reloadData()
    {
        tableView.reloadData()
        
    }
    
    private func reloadViewWithIndex(index: Int)
    {
        defaultIndex = index
        var object: AnyObject = list[defaultIndex]
        self.helper.setCurrentView(object)
    }
    
    
    //MARK: Tap Action
    private func tapTheCombox()
    {
        setupTable()
        closeOtherCombox()
        closeCurrentCombox()
        openCurrentCombox()
        
        self.delegate.tapComboxToOpenTable?(self)
    }
    
    
    //MARK: helper
    private func dismissCombox()
    {
        reloadViewWithIndex(defaultIndex)
        tapTheCombox()
        delegate.selectedAtIndex?(defaultIndex, combox: self)
    }
    
    
    private func closeOtherCombox()
    {
        closeSubCombox(supView)
    }
    
    private func closeSubCombox(subV: UIView)
    {
        if (subV.isKindOfClass(SWComboxView)) && (subV as! SWComboxView != self)
        {
            (subV as! SWComboxView).closeCurrentCombox()
        }
        else
        {
            var childViews:[AnyObject] = subV.subviews
            if !childViews.isEmpty
            {
                for childV in childViews
                {
                    closeSubCombox(childV as! UIView)
                }
            }
        }
    }
    
    private func closeCurrentCombox()
    {
        if self.isOpen
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                var frame = self.tableView.frame
                frame.size.height = 0
                self.tableView.frame = frame
            })
            
            UIView.animateWithDuration(0.3,
                animations: { () -> Void in
                    var frame = self.tableView.frame
                    frame.size.height = 0
                    self.tableView.frame = frame
                },
                completion: { finished in
                    self.tableView.removeFromSuperview()
                    self.isOpen = false
                    self.arrow.transform = CGAffineTransformRotate(self.arrow.transform,   CGFloat(M_PI))
            })
        }
    }
    
    private func openCurrentCombox()
    {
        if !self.isOpen
        {
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                if self.list.count > 0
                {
                    self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
                }
                self.supView.addSubview(self.tableView)
                self.supView.bringSubviewToFront(self.tableView)
                self.tableView.frame = self.getTableFrame()
                }, completion: { finished in
                    self.isOpen = true
                    self.arrow.transform = CGAffineTransformRotate(self.arrow.transform, CGFloat(M_PI))
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
        return CGRectMake(orginX, orginY, self.frame.size.width, 0)
    }
    
    private func getTableFrame() -> CGRect
    {
        var frame  = tableView.frame
        var countNumber = self.list.count > 4 ? 4.5 : CGFloat(self.list.count)
        frame.size.height = self.contentView.frame.height * countNumber
        var fullHeight = UIScreen.mainScreen().bounds.size.height
        if frame.origin.y + frame.size.height > fullHeight
        {
            frame.size.height == fullHeight - frame.origin.y
        }
        return frame
    }
}
