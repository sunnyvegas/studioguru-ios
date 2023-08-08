//
//  MainDashboard.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/6/23.
//

import UIKit

class MainDashboard:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    var sideMenu:SideMenu!
    var dimCon:UIButton!
    
    var pagesA:NSMutableArray = NSMutableArray()
    
    var isMenuOpen:Bool = false
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        
        
        sideMenu = SideMenu(frame: sharedData.fullRect)
        addSubview(sideMenu)
        
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        
        dimCon = UIButton(type: .custom)
        dimCon.frame = sharedData.fullRect
        dimCon.backgroundColor = UIColor(white: 0, alpha: 0.5)
        dimCon.isHidden = true
        dimCon.addEventListener(selector: #selector(self.hideMenu), target: self)
        addSubview(dimCon)
        
        let page1 = MyAccount(frame: sharedData.fullRect)
        let page2 = Chat(frame: sharedData.fullRect)
        
        pagesA.add(page1)
        pagesA.add(page2)
        
        
        sharedData.addEventListener(title: "SHOW_MENU", target: self, selector: #selector(self.showMenu))
        sharedData.addEventListener(title: "TOGGLE_MENU", target: self, selector: #selector(self.toggleMenu))
        
        updatePages()
    }
    
    func initClass()
    {
    
    }
    
    @objc func toggleMenu()
    {
        if(isMenuOpen == false)
        {
            showMenu()
        }else{
            hideMenu()
        }
        
        
    }
    
    @objc func showMenu()
    {
        dimCon.isHidden = false
        UIView.animate(withDuration: 0.25)
        {
            self.dimCon.x = 300
            self.mainCon.x = 300
        }
        
        isMenuOpen = true
    }
    
    @objc func hideMenu()
    {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations:
        {
            self.mainCon.x = 0
            self.dimCon.x = 0
        }, completion: {
        finished in
            self.dimCon.isHidden = true
        })
        
        isMenuOpen = false
    }
    
    @objc func updatePages()
    {
        mainCon.removeSubViews()
        
        for i in 0..<pagesA.count
        {
            if(CGFloat(i) == sharedData.cPage)
            {
                let page = (pagesA.object(at: i) as! BasePage)
                mainCon.addSubview(page)
                page.initClass()
            }
        }
        
        UIView.animate(withDuration: 0.25)
        {
            self.mainCon.x = 0
        }
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
