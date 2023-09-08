//
//  NoInternet.swift
//  StudioGuru
//
//  Created by Sunny Clark on 9/8/23.
//

import UIKit

class NoInternet:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    
    
   override init (frame : CGRect)
   {
       super.init(frame : frame)
       sharedData = SharedData.sharedInstance
       backgroundColor = .white
       
       let topBar = sharedData.getTopBarBig(title: "No Internet")
       addSubview(topBar)
       
       let title = UILabel()
       title.width = sharedData.screenWidth
       title.text = "You have no internet access."
       title.textColor = .black
       title.textAlignment = .center
       title.height = 20
       title.y = topBar.posY() + 20
       addSubview(title)
   }
    
    func initClass()
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
