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
    
    var cBanner:UIView!
    
    var isShowingBanner = false
    
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
        let page10 = FeedPage(frame: sharedData.fullRect)
        
        pagesA.add(page1)
        pagesA.add(page2)
        pagesA.add(page3)
        pagesA.add(page4)
        pagesA.add(page5)
        pagesA.add(page6)
        pagesA.add(page7)
        pagesA.add(page8)
        pagesA.add(page9)
        pagesA.add(page10)
        
        
        
        sharedData.addEventListener(title: "SHOW_MENU", target: self, selector: #selector(self.showMenu))
        sharedData.addEventListener(title: "TOGGLE_MENU", target: self, selector: #selector(self.toggleMenu))
        sharedData.addEventListener(title: "HIDE_MENU", target: self, selector: #selector(self.hideMenu))
        sharedData.addEventListener(title: "UPDATE_PAGES", target: self, selector: #selector(self.updatePages))
        sharedData.addEventListener(title: "APP_LOADED", target: self, selector: #selector(self.updateToken))
        
        
        sharedData.cPage = 1
        updatePages()
        
        sharedData.addEventListener(title: "SHOW_CHAT_BANNER", target: self, selector: #selector(self.showChatBanner))
        
        sharedData.setTimeout(delay: 3.0, block: {
            //self.showChatBanner()
        })
    }
    
    func initClass()
    {
    
    }
    
    @objc func showChatBanner()
    {
        let banner = sharedData.getTopBarBig(title: sharedData.tmp_chat_title + " - New Message")
        banner.backgroundColor = .black
        banner.titleLabel.textColor = .white
        banner.titleLabel.font = .systemFont(ofSize: 17)
        banner.titleLabel.textAlignment = .left
        banner.titleLabel.x = 50
        banner.y = banner.height * -1
        addSubview(banner)
        banner.animateUp()
        
        
        let img = UIImageView()
        img.width = 30
        img.height = 30
        img.x = 10
        img.y = 45
        img.corner(radius: 15)
        img.downloadedFrom(link: sharedData.base_domain + "/api-ios/chat-photo/" + sharedData.tmp_chat_id)
        banner.addSubview(img)
        
        let btn = UIButton(type: .custom)
        btn.width = banner.width
        btn.height = banner.height
        btn.backgroundColor = .clear
        btn.addEventListener(selector: #selector(self.goChat), target: self)
        banner.addSubview(btn)
        
        banner.addExitRight(selector: #selector(self.goExitBanner), target: self)
        cBanner = banner
        
        isShowingBanner = true
        
        sharedData.setTimeout(delay: 5.0, block: {
            self.hideBanner()
        })
    }
    
    @objc func hideBanner()
    {
        if(isShowingBanner == true)
        {
            isShowingBanner = false
            UIView.animate(withDuration: 0.25)
            {
                self.cBanner.y = self.cBanner.height * -1
            }
        }
    }
    
    @objc func goChat()
    {
        isShowingBanner = false
        sharedData.chat_id = sharedData.tmp_chat_id
        sharedData.chat_title = sharedData.tmp_chat_title
        
        sharedData.canLoadChat = true
        sharedData.postEvent(event: "RELOAD_SIDEMENU")
        sharedData.postEvent(event: "HIDE_MENU")
        sharedData.cPage = 5
        sharedData.postEvent(event: "UPDATE_PAGES")
        
        
        //sharedData.showMessage(title: "alert", message: "yes!")
        goExitBanner()
    }
    
    @objc func goExitBanner()
    {
        isShowingBanner = false
        cBanner.removeFromSuperview()
    }
    
    @objc func updateToken()
    {
        ///:studio_id/api-ios/update-token
        sharedData.postIt(urlString: sharedData.base_domain + "/api-ios/update-token", params: ["device_token":sharedData.device_token], callback: {
            success, result_dict in
            
            print("TOKEN_UPDATED-",self.sharedData.device_token)
        })
        
        if(SharedData.sharedInstance.didOpenFromPush == true)
        {
            sharedData.postEvent(event: "HIDE_MENU")
            sharedData.cPage = 5
            sharedData.postEvent(event: "RELOAD_SIDEMENU")
            sharedData.postEvent(event: "UPDATE_PAGES")
        }
        SharedData.sharedInstance.didOpenFromPush = false
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
