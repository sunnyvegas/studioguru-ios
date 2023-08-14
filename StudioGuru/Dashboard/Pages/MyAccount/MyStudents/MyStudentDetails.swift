//
//  StudentDetails.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/12/23.
//

import UIKit

class MyStudentDetails:UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
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
        mainCon.width = sharedData.screenWidth * 2
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
        mainDataA.add("Programs/Classes")
  
        
        iconsA.add("icon_personal_info")
        iconsA.add("icon_classes")
        
        sharedData.addEventListener(title: "MYSTUDENT_DETAILS_HOME", target: self, selector: #selector(self.goBackDetails))
        sharedData.addEventListener(title: "STUDENT_DETAILS_RELOAD", target: self, selector: #selector(self.loadData))
    }
    
    func initClass()
    {
        topBar.titleLabel.text = (sharedData.studentDict.object(forKey: "student_name") as! String)
    }
    
    @objc func loadData()
    {
        sharedData.getIt(urlString: sharedData.base_domain + "/api-ios/student-details/" + (sharedData.studentDict.object(forKey: "student_id") as! String), params: [:], callback: {
            succes, result_dict in
            
            if((result_dict.object(forKey: "success") as! Bool) == true)
            {
                self.sharedData.studentDict.removeAllObjects()
                self.sharedData.studentDict.addEntries(from: ((result_dict.object(forKey: "result") as! NSDictionary) as! [AnyHashable : Any]))
                self.sharedData.postEvent(event: "STUDENT_INFO_RELOAD")
                self.sharedData.postEvent(event: "RELOAD_MYSTUDENTS")
            }
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
        
        if(indexPath.row == 0)
        {
            let page = MyStudentInfo(frame: sharedData.fullRect)
            page.x = sharedData.screenWidth
            page.initClass()
            mainCon.addSubview(page)
            UIView.animate(withDuration: 0.25, animations:
            {
                self.mainCon.x = self.sharedData.screenWidth * -1
            })
        }
    }
    
    @objc func goBackDetails()
    {
        UIView.animate(withDuration: 0.25, animations:
        {
            self.mainCon.x = 0
        })
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
