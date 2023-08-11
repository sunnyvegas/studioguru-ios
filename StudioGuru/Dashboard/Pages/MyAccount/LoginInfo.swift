//
//  LoginInfo.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/10/23.
//

import UIKit

class LoginInfo:BasePage, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    
    
    override init (frame : CGRect)
    {
       super.init(frame : frame)
       sharedData = SharedData.sharedInstance
       backgroundColor = .white
        
        let topBar = sharedData.getTopBarBig(title: "Login Info")
        topBar.addBack(selector: #selector(self.goBack), target: self)
        addSubview(topBar)
    }
    
    override func initClass()
    {
    
    }
    
    @objc func goBack()
    {
        sharedData.postEvent(event: "MY_ACCOUNT_HOME")
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
