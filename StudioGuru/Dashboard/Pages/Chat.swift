//
//  Chat.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//

import UIKit


class Chat:BasePage,UITableViewDelegate, UITableViewDataSource
{
    var sharedData:SharedData!
    
    var mainDataA:NSMutableArray = NSMutableArray()
    
    var feedList:UITableView!
    
    var mainCon:UIView!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = sharedData.bkColor
        
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        
        let topBar = sharedData.getTopBarBig(title: "Chat")
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
        feedList.register(ChatCell.self, forCellReuseIdentifier: "chat_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
        
        
    }
    
    override func initClass()
    {
        loadData()
    }
    
    @objc func loadData()
    {
        mainDataA.removeAllObjects()
        feedList.reloadData()
        sharedData.getIt(urlString: sharedData.base_domain + "/api-member/chat/list", params: [:], callback:
        {   success, result_dict in
            
            self.mainDataA.addObjects(from: (result_dict.object(forKey: "result") as! Array<Any>) )
            
            self.feedList.reloadData()
            
            
        })
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
        let cell = ChatCell(style: .default, reuseIdentifier: "chat_cell")
        
        let data = mainDataA.object(at: indexPath.row) as! NSDictionary
        cell.title.text = (data.object(forKey: "title") as! String)
        cell.img.downloadedFrom(link: (data.object(forKey: "photo") as! String))
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        let data = mainDataA.object(at: indexPath.row) as! NSDictionary
        
        sharedData.chat_title = (data.object(forKey: "title") as! String)
        sharedData.chat_id = (data.object(forKey: "chat_id") as! String)
      
        
        
        sharedData.postEvent(event: "GO_CHAT")
      
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
