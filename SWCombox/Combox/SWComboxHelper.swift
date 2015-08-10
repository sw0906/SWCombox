//
//  SWComboxTitleHelper.swift
//  AuntFood
//
//  Created by shouwei on 3/8/15.
//  Copyright (c) 2015 shou. All rights reserved.
//

import UIKit

protocol SWComboxCommonHelper {
    
    func loadCurrentView(contentView:UIView, data: AnyObject)
    
    func setCurrentView(data: AnyObject)
    
    func getCurrentCell(tableView: UITableView, data: AnyObject) -> UITableViewCell
    
    func getCurrentTitle() -> String
    
}



class SWComboxTitleHelper: SWComboxCommonHelper {
    
    var comboxView:SWComboxTitle!
    
    func loadCurrentView(contentView:UIView, data: AnyObject)
    {
        comboxView = UIView.loadInstanceFromNibNamedToContainner(contentView)
        comboxView.bindTitle(data)
    }
    
    func setCurrentView(data: AnyObject){
        comboxView.bindTitle(data)
    }
    
    func getCurrentCell(tableView: UITableView, data: AnyObject) -> UITableViewCell {
        var cellFrame = comboxView.frame
        cellFrame.size.width = tableView.frame.size.width
        
        var cell = UITableViewCell()
        cell.frame = cellFrame
        
        var comboxV : SWComboxTitle
        comboxV = UIView.loadInstanceFromNibNamedToContainner(cell)!
        comboxV.bindTitle(data)
        return cell
    }
    
    func getCurrentTitle() -> String {
        return self.comboxView.name.text!
    }
    
}

class SWComboxCountryHelper: SWComboxCommonHelper {
    
    var comboxView:SWComboxCountry!
    
    func loadCurrentView(contentView:UIView, data: AnyObject)
    {
        comboxView = UIView.loadInstanceFromNibNamedToContainner(contentView)
        comboxView.bindCountry(data as! SWCountry)
    }
    
    func setCurrentView(data: AnyObject){
        comboxView.bindCountry(data as! SWCountry)
    }
    
    func getCurrentCell(tableView: UITableView, data: AnyObject) -> UITableViewCell {
        var cellFrame = comboxView.frame
        cellFrame.size.width = tableView.frame.size.width
        
        var cell = UITableViewCell()
        cell.frame = cellFrame
        
        var comboxV : SWComboxCountry
        comboxV = UIView.loadInstanceFromNibNamedToContainner(cell)!
        comboxV.bindCountry(data as! SWCountry)
        return cell
    }
    
    func getCurrentTitle() -> String {
        return self.comboxView.name.text!
    }
}





