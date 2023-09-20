//
//  SideMenu.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/7/23.
//

import UIKit

class SideMenu:UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    var sharedData:SharedData!
    
    var studioImg:UIImageView!
    var custImg:UIImageView!
    
    var mainCon:UIView!
    
    var feedList:UITableView!
    
    var mainDataA:NSMutableArray = NSMutableArray()
    var iconsA:NSMutableArray = NSMutableArray()
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        
        
        feedList = UITableView();
        feedList.width = sharedData.screenWidth * 0.8
        feedList.y = 50
        feedList.height = sharedData.screenHeight - feedList.y
        feedList.backgroundColor = UIColor.clear
        feedList.delegate = self
        feedList.dataSource = self
        feedList.showsVerticalScrollIndicator = false
        feedList.separatorStyle = .none
        feedList.register(SideMenuCell.self, forCellReuseIdentifier: "sidemenu_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
        
        
        sharedData.addEventListener(title: "APP_LOADED", target: self, selector: #selector(self.initClass))
        
        sharedData.addEventListener(title: "RELOAD_SIDEMENU", target: self, selector: #selector(self.realoadMenu))
    }
    
    @objc func realoadMenu()
    {
        feedList.reloadData()
    }
    
    @objc func initClass()
    {
        mainDataA.removeAllObjects()
        iconsA.removeAllObjects()
        
        mainDataA.add(sharedData.studio_name!)
        iconsA.add(sharedData.base_domain + "/logo")
        
        mainDataA.add(sharedData.member_name!)
        iconsA.add(sharedData.base_domain + "/member-photo/" + sharedData.member_id)
        
        
        mainDataA.add("Manager")
        iconsA.add("icon_manager")
        
        mainDataA.add("Instructor")
        iconsA.add("icon_instructor")
        
        mainDataA.add("Staff")
        iconsA.add("icon_staff")
        
        mainDataA.add("Chat")
        iconsA.add("icon_chat")
        
        mainDataA.add("Programs/Classes")
        iconsA.add("icon_classes")
        
        mainDataA.add("Store")
        iconsA.add("icon_store")
        
        mainDataA.add("Studio Rentals")
        iconsA.add("icon_studio_rentals")
        
        mainDataA.add("Log Out")
        iconsA.add("icon_login_info")
        
        feedList.reloadData()
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
       
        if(indexPath.row < 2)
        {
            return 80
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        mainDataA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = SideMenuCell(style: .default, reuseIdentifier: "sidemenu_cell")
        
        let title = mainDataA.object(at: indexPath.row) as! String
        cell.accessoryType = .disclosureIndicator
        
        if(indexPath.row == 0 && sharedData.owner == false)
        {
            cell.accessoryType = .none
        }
        
        cell.title.text = title
        cell.title.font = sharedData.normalFont(size: 22)
        cell.backgroundColor = .white
        cell.title.textColor = .black
        cell.badge.isHidden = true
        if(indexPath.row < 2)
        {
            cell.image.downloadedFrom(link: (iconsA.object(at: indexPath.row) as! String))
            cell.image.tintColor = .black
            cell.image.width = 60
            cell.image.height = 60
            cell.image.corner(radius: 30)
            cell.image.layer.borderColor = UIColor.lightGray.cgColor
            cell.image.layer.borderWidth = 1
            cell.line.y = 79
            cell.title.x = cell.image.posX() + 10
            cell.title.y = 20
            
        }else{
            cell.image.image = UIImage(named: (iconsA.object(at: indexPath.row) as! String) )?.withRenderingMode(.alwaysTemplate)
            cell.image.tintColor = .black
            
            if(CGFloat(indexPath.row) == sharedData.cPage)
            {
                cell.image.tintColor = .white
            }
            
            
        }
        
        if(CGFloat(indexPath.row) == sharedData.cPage)
        {
            cell.title.font = sharedData.boldFont(size: 22)
            cell.title.textColor = .white
            cell.backgroundColor = sharedData.gray
        }
        
        if(indexPath.row == 5 && sharedData.chat_badge_count != "0")
        {
            cell.badge.isHidden = false
            cell.badge.text = ""//sharedData.chat_badge_count
            sharedData.badge_label = cell.badge
        }
        
        if(title == "Log Out")
        {
            cell.backgroundColor = UIColor(hex: 0xaa0000)
            cell.title.textColor = .white
            cell.image.tintColor = .white
        }
        
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 0 && sharedData.owner == false)
        {
            return
        }
        
        let title = mainDataA.object(at: indexPath.row) as! String
        if(title == "Log Out")
        {
            sharedData.showMessageCBConfirm(title: "Alert", message: "Are you sure you want to log out?", callbackY:
            {
                self.sharedData.postEvent(event: "HIDE_MENU")
                self.sharedData.setTimeout(delay: 0.4, block:
                {
                    self.sharedData.postEvent(event: "LOG_OUT")
                })
                
            }, callbackN: {
                
            })
            return
        }
        
        
        sharedData.postEvent(event: "HIDE_MENU")
        sharedData.cPage = CGFloat(indexPath.row)
        sharedData.postEvent(event: "UPDATE_PAGES")
        feedList.reloadData()
        
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
