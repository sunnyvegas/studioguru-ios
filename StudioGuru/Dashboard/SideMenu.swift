//
//  SideMenu.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/7/23.
//

import UIKit

class SideMenu:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var studioImg:UIImageView!
    var custImg:UIImageView!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        studioImg = UIImageView()
        studioImg.width = 60
        studioImg.height = 60
        studioImg.y = 80
        studioImg.x = 10
        studioImg.backgroundColor = .darkGray
        studioImg.corner(radius: 30)
        addSubview(studioImg)
        
        custImg = UIImageView()
        custImg.width = 60
        custImg.height = 60
        custImg.y = studioImg.posY() + 20
        custImg.x = 10
        custImg.backgroundColor = .darkGray
        custImg.corner(radius: 30)
        addSubview(custImg)
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
