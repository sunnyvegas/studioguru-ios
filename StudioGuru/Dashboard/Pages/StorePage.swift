//
//  StorePage.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/10/23.
//

import UIKit

class StorePage:BasePage, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    
    
    override init (frame : CGRect)
    {
       super.init(frame : frame)
       sharedData = SharedData.sharedInstance
       backgroundColor = .white
        
        let topBar = sharedData.getTopBarBig(title: "Store")
        topBar.addMenu()
        addSubview(topBar)
    }
    
    override func initClass()
    {
    
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
