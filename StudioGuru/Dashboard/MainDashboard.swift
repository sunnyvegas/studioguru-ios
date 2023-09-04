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
        
        let page1 = StudioPage(frame: sharedData.fullRect)
        let page2 = MyAccount(frame: sharedData.fullRect)
        let page3 = ManagerPage(frame: sharedData.fullRect)
        let page4 = InstructorPage(frame: sharedData.fullRect)
        let page5 = StaffPage(frame: sharedData.fullRect)
        let page6 = Chat(frame: sharedData.fullRect)
        let page7 = ClassesPage(frame: sharedData.fullRect)
        let page8 = StorePage(frame: sharedData.fullRect)
        let page9 = StudioRentals(frame: sharedData.fullRect)
        
        pagesA.add(page1)
        pagesA.add(page2)
        pagesA.add(page3)
        pagesA.add(page4)
        pagesA.add(page5)
        pagesA.add(page6)
        pagesA.add(page7)
        pagesA.add(page8)
        pagesA.add(page9)
        
        
        
        sharedData.addEventListener(title: "SHOW_MENU", target: self, selector: #selector(self.showMenu))
        sharedData.addEventListener(title: "TOGGLE_MENU", target: self, selector: #selector(self.toggleMenu))
        sharedData.addEventListener(title: "HIDE_MENU", target: self, selector: #selector(self.hideMenu))
        sharedData.addEventListener(title: "UPDATE_PAGES", target: self, selector: #selector(self.updatePages))
        sharedData.addEventListener(title: "APP_LOADED", target: self, selector: #selector(self.updateToken))
        
        
        sharedData.cPage = 1
        updatePages()
    }
    
    func initClass()
    {
    
    }
    
    @objc func updateToken()
    {
        ///:studio_id/api-ios/update-token
        sharedData.postIt(urlString: sharedData.base_domain + "/api-ios/update-token", params: ["device_token":sharedData.device_token], callback: {
            success, result_dict in
            
            print("TOKEN_UPDATED-",self.sharedData.device_token)
        })
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
            self.dimCon.x = self.sharedData.screenWidth * 0.8
            self.mainCon.x = self.sharedData.screenWidth * 0.8
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
