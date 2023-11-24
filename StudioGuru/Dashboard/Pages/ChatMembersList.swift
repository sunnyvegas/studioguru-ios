//
//  ChatMembersList.swift
//  StudioGuru
//
//  Created by Sunny Clark on 10/25/23.
//

import UIKit

class ChatMembersList:UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
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
        
        let topBar = sharedData.getTopBarBig(title: sharedData.chat_title + " Members")
        topBar.addExit(selector: #selector(self.goExit), target: self)
        addSubview(topBar)
        
        
        feedList = UITableView();
        feedList.width = sharedData.screenWidth
        feedList.y = topBar.posY()
        feedList.height = sharedData.screenHeight - feedList.y
        feedList.backgroundColor = UIColor.clear
        feedList.delegate = self
        feedList.dataSource = self
        feedList.showsVerticalScrollIndicator = false
        feedList.separatorStyle = .none
        feedList.register(ChatCell.self, forCellReuseIdentifier: "chat_members_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
        
    }
    
    func initClass()
    {
        feedList.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        mainDataA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = ChatCell(style: .default, reuseIdentifier: "chat_members_cell")
        
        let data = mainDataA.object(at: indexPath.row) as! NSDictionary
        //cell.accessoryType = .disclosureIndicator
        cell.title.text = (data.object(forKey: "member_name") as! String)
        cell.title.font = sharedData.normalFont(size: 20)
        cell.img.downloadedFrom(link: sharedData.base_domain + "/api-ios/member-photo/" + (data.object(forKey: "member_id") as! String) )
        //cell.image.image = UIImage(named: (iconsA.object(at: indexPath.row) as! String) )?.withRenderingMode(.alwaysTemplate)
        //cell.image.tintColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    @objc func goExit()
    {
        animateDown()
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
