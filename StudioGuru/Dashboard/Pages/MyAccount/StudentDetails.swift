//
//  StudentDetails.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/12/23.
//

import UIKit

class StudentDetails:UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    var sharedData:SharedData!
    
    var studioImg:UIImageView!
    var custImg:UIImageView!
    
    var mainCon:UIView!
    
    var feedList:UITableView!
    
    var mainDataA:NSMutableArray = NSMutableArray()
    var iconsA:NSMutableArray = NSMutableArray()
    var topBar:TopBar!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        
        topBar = sharedData.getTopBarBig(title: "Student Details")
        topBar.addBack(selector: #selector(self.goBack), target: self)
        mainCon.addSubview(topBar)
        
        feedList = UITableView();
        feedList.width = sharedData.screenWidth
        feedList.y = topBar.posY()
        feedList.height = sharedData.screenHeight - feedList.y
        feedList.backgroundColor = UIColor.clear
        feedList.delegate = self
        feedList.dataSource = self
        feedList.showsVerticalScrollIndicator = false
        feedList.separatorStyle = .none
        feedList.register(MyAccountCell.self, forCellReuseIdentifier: "sd_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
        
        mainDataA.add("Personal Info")
  
        
        iconsA.add("icon_personal_info")
   
        
    }
    
    func initClass()
    {
        topBar.titleLabel.text = (sharedData.studentDict.object(forKey: "student_name") as! String)
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
        let cell = MyAccountCell(style: .default, reuseIdentifier: "sd_cell")
        
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
    
    @objc func goBack()
    {
        sharedData.postEvent(event: "MYSTUDENTS_HOME")
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
