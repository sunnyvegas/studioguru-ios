//
//  Account.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/5/23.
//

import UIKit

class MyAccount:BasePage, UITextFieldDelegate,UITableViewDelegate, UITableViewDataSource
{
    var sharedData:SharedData!
    
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
        
        let topBar = sharedData.getTopBarBig(title: "My Account")
        topBar.addMenu()
        addSubview(topBar)
        
        mainDataA.add("Personal Info")
        mainDataA.add("Login Info")
        mainDataA.add("Students")
        mainDataA.add("Payment Methods")
        
        iconsA.add("icon_personal_info")
        iconsA.add("icon_login_info")
        iconsA.add("icon_students")
        iconsA.add("icon_payment_methods")
        
        
        feedList = UITableView();
        feedList.width = sharedData.screenWidth
        feedList.y = topBar.posY()
        feedList.height = sharedData.screenHeight - feedList.y
        feedList.backgroundColor = UIColor.clear
        feedList.delegate = self
        feedList.dataSource = self
        feedList.showsVerticalScrollIndicator = false
        feedList.separatorStyle = .none
        feedList.register(MyAccountCell.self, forCellReuseIdentifier: "myaccount_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
    }
    
    override func initClass()
    {
    
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
        let cell = MyAccountCell(style: .default, reuseIdentifier: "myaccount_cell")
        
        let title = mainDataA.object(at: indexPath.row) as! String
        cell.accessoryType = .disclosureIndicator
        cell.title.text = title
        cell.title.font = sharedData.normalFont(size: 20)
        cell.image.image = UIImage(named: (iconsA.object(at: indexPath.row) as! String) )?.withRenderingMode(.alwaysTemplate)
        cell.image.tintColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
