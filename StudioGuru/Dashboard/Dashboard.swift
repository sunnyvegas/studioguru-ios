//
//  Dashboard.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//

import UIKit


class Dashboard:UIView
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    
    var bottomBar:UIView!
    
    var cPage:Int!
    
    var pagesA:NSMutableArray = NSMutableArray()
    var btnsA:NSMutableArray = NSMutableArray()
    var iconsA:NSMutableArray = NSMutableArray()
    var titlesA:NSMutableArray = NSMutableArray()
    
    var btnHome:UIButton!
    var btnCal:UIButton!
    var btnMessages:UIButton!
    var btnNoti:UIButton!
    var btnMore:UIButton!
    
    var bottomHeight:CGFloat = 70
    
    var btn_count:Int!
    
    var chatDetails:ChatDetails!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        cPage = 0
        btn_count = 0
        
        mainCon = UIView()
        mainCon.width = sharedData.screenWidth * 3
        mainCon.height = sharedData.screenHeight
        addSubview(mainCon)
        
   
        if(sharedData.screenHeight < 700)
        {
            bottomHeight = 60
        }
        
        
        bottomBar = UIView()
        bottomBar.height = 65
        bottomBar.width = sharedData.screenWidth
        bottomBar.alpha = 1.0
        
        bottomBar.y = sharedData.screenHeight - bottomHeight
        bottomBar.backgroundColor = .gray
       // bottomBar.backgroundColor = .white
        
        
        
        btnHome = createBtn(title: "Home", icon: "icon_home")
        btnHome.tag = 10
        bottomBar.addSubview(btnHome)
        
        btnCal = createBtn(title: "Calendar", icon: "icon_cal")
        btnCal.tag = 11
        bottomBar.addSubview(btnCal)
        
        
        btnMessages = createBtn(title: "Chat", icon: "icon_chat")
        btnMessages.tag = 12
        bottomBar.addSubview(btnMessages)
        
        
        btnMore = createBtn(title: "More", icon: "icon_more")
        btnMore.tag = 13
        bottomBar.addSubview(btnMore)
        
        
       

        
        mainCon.addSubview(bottomBar)
        
        
        
        let pageHome = Home(frame: sharedData.fullRect)
        pagesA.add(pageHome)
        mainCon.addSubview(pageHome)
        
        
        let pageCal = CalendarPage(frame: sharedData.fullRect)
        pagesA.add(pageCal)
        mainCon.addSubview(pageCal)
        
        
        let pageChat = Chat(frame: sharedData.fullRect)
        pagesA.add(pageChat)
        mainCon.addSubview(pageChat)
        
        let pageMore = More(frame: sharedData.fullRect)
        pagesA.add(pageMore)
        mainCon.addSubview(pageMore)
        
        chatDetails = ChatDetails(frame: sharedData.fullRect)
        chatDetails.x = sharedData.screenWidth
        mainCon.addSubview(chatDetails)
        
        updatePages()
        
        sharedData.addEventListener(title: "GO_CHAT", target: self, selector: #selector(self.goChat))
        sharedData.addEventListener(title: "GO_BACK_CHAT", target: self, selector: #selector(self.goBackChat))
        
        
    }
    
    @objc func initClass()
    {
        
    }
    
   
    
    @objc func goChat()
    {
        chatDetails.initClass()
        mainCon.addSubview(chatDetails)
        UIView.animate(withDuration: 0.25)
        {
            self.mainCon.x = self.sharedData.screenWidth * -1
        }
    }
    
    @objc func goBackChat()
    {
        UIView.animate(withDuration: 0.25)
        {
            self.mainCon.x = 0
        }
    }
    
    func createBtn(title:String, icon:String) -> UIButton
    {
        let btn = UIButton(type: .custom)
        btn.x = 0
        btn.y = 0
        
        btn.width = sharedData.screenWidth/4
        btn.height = bottomHeight
        btn.addEventListener(selector: #selector(self.btnHandler), target: self)
        
        btn.x = CGFloat(btn_count) * btn.width
        
        btn_count = btn_count + 1
        
        let imgHome = UIImageView()
        imgHome.width = 30
        imgHome.height = 30
        imgHome.y = 5
        imgHome.padding(num: 5)
        imgHome.image = UIImage(named:icon)?.withRenderingMode(.alwaysTemplate)
        imgHome.tintColor = sharedData.gray
        imgHome.contentMode = .scaleAspectFit
        imgHome.x = ((sharedData.screenWidth/4) - 30)/2
        btn.addSubview(imgHome)
        
        
        //btnsIconsA.add(imgHome)
        
        let homeLabel = UILabel()
        homeLabel.width = sharedData.screenWidth/4
        homeLabel.textAlignment = NSTextAlignment.center
        homeLabel.height = 15
        homeLabel.y = 35
        homeLabel.textColor = sharedData.gray
        homeLabel.text = title
        homeLabel.font = UIFont.systemFont(ofSize: 9)
        homeLabel.isUserInteractionEnabled = false
        btn.addSubview(homeLabel)
        
        
        titlesA.add(homeLabel)
        iconsA.add(imgHome)
        btnsA.add(btn)
        
        return btn
    }
    
    @objc func btnHandler(btn:UIButton)
    {
        cPage = btn.tag - 10
        updatePages()
        print("btn.tag---->",btn.tag)
       
    }
    
    
    
    func updatePages()
    {
        mainCon.removeSubViews()
        for i in 0..<pagesA.count
        {
            let page = pagesA.object(at: i) as! BasePage
            page.isHidden = !(i == cPage)
            if(i == cPage)
            {
                mainCon.addSubview(page)
                page.initClass()
            }
        }
        
        for i in 0..<btnsA.count
        {
            let btn = (btnsA.object(at: i) as! UIButton)
            let icon = (iconsA.object(at: i) as! UIImageView)
            let title = (titlesA.object(at: i) as! UILabel)
            if(i == cPage)
            {
                btn.alpha = 1
                btn.backgroundColor = sharedData.gray
                icon.tintColor = .white
                title.textColor = .white
                
            }else{
                btn.alpha = 1
                btn.backgroundColor = .white
                icon.tintColor = sharedData.gray
                title.textColor = sharedData.gray
            }
        }
        
        mainCon.addSubview(bottomBar)
        
        let borderTop = UIView()
        borderTop.width = sharedData.screenWidth
        borderTop.height = 1
        borderTop.backgroundColor = sharedData.gray
        borderTop.y = sharedData.screenHeight - bottomHeight - 1
        mainCon.addSubview(borderTop)
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
