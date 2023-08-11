//
//  OwnerPage.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/10/23.
//

import UIKit

class StudioPage:BasePage, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var topBar:TopBar!
    
    override init (frame : CGRect)
    {
       super.init(frame : frame)
       sharedData = SharedData.sharedInstance
       backgroundColor = .white
        
        topBar = sharedData.getTopBarBig(title: "Studio Portal")
        topBar.addMenu()
        addSubview(topBar)
        
        sharedData.addEventListener(title: "APP_LOADED", target: self, selector: #selector(self.initClass))
    }
    
    @objc override  func initClass()
    {
        topBar.titleLabel.text = sharedData.studio_name
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
