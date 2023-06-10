//
//  More.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//
import UIKit

class More:BasePage
{
    var sharedData:SharedData!
    
  
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = sharedData.bkColor
        
        let topBar = sharedData.getTopBarBig(title: "More")
        addSubview(topBar)
    }
    
    convenience init ()
    {
       self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder)
    {
       fatalError("This class does not support NSCoding")
    }
    
}
