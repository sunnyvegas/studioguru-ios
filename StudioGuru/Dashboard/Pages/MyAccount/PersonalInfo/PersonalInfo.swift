//
//  PersonalInfo.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/10/23.
//

import UIKit

class PersonalInfo:BasePage,UITableViewDelegate, UITableViewDataSource
{
    var sharedData:SharedData!
    
    var mainDataA:NSMutableArray = NSMutableArray()
    var mainLabelsA:NSMutableArray = NSMutableArray()
    var mainKeysA:NSMutableArray = NSMutableArray()
    
    var mainCon:UIView!
    
    var feedList:UITableView!
    
    var pageEditItem:PageEditItem!
    var pageEditPhoto:PageEditPhoto!
    
    var actInd:UIActivityIndicatorView!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        mainCon = UIView(frame: sharedData.fullRect)
        mainCon.width = sharedData.screenWidth * 2
        addSubview(mainCon)
        
        let topBar = sharedData.getTopBarBig(title: "Personal Info")
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
        //feedList.separatorStyle = .none
        feedList.register(PICell.self, forCellReuseIdentifier: "pi_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
        
        pageEditItem = PageEditItem(frame: sharedData.fullRect)
        pageEditItem.x = sharedData.screenWidth
        
        pageEditPhoto = PageEditPhoto(frame: sharedData.fullRect)
        pageEditPhoto.x = sharedData.screenWidth
        
        actInd = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.hidesWhenStopped = true
        actInd.center = CGPoint(x: sharedData.screenWidth * 0.5, y: 130)
        actInd.style = .large
        actInd.tintColor = .black
        actInd.startAnimating()
        
        sharedData.addEventListener(title: "EDIT_BACK", target: self, selector: #selector(self.goBackEdit))
        sharedData.addEventListener(title: "INFO_RELOAD", target: self, selector: #selector(self.loadData))
    }
    
    override func initClass()
    {
        loadData()
    }
    
    @objc func loadData()
    {
        
        mainCon.addSubview(actInd)
        self.mainLabelsA.removeAllObjects()
        self.feedList.reloadData()
        
        sharedData.getIt(urlString: sharedData.base_domain + "/api-ios/details", params: [:], callback:
        {
            success, result_dict in
            
            
            print("RESULT")
            print(result_dict)
            
            self.mainDataA.removeAllObjects()
            
            self.mainDataA.add(((result_dict.object(forKey: "result") as! NSDictionary).object(forKey: "photo") as! String) )
            self.mainDataA.add(((result_dict.object(forKey: "result") as! NSDictionary).object(forKey: "member_name") as! String) )
            self.mainDataA.add(((result_dict.object(forKey: "result") as! NSDictionary).object(forKey: "phone") as! String) )
            
            
            self.mainKeysA.removeAllObjects()
            self.mainKeysA.add("photo")
            self.mainKeysA.add("member_name")
            self.mainKeysA.add("phone")
            
            self.mainLabelsA.removeAllObjects()
            self.mainLabelsA.add("Photo")
            self.mainLabelsA.add("Full Name")
            self.mainLabelsA.add("Phone")
            
            self.actInd.removeFromSuperview()
            
            self.feedList.reloadData()
            
        })
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if(indexPath.row == 0)
        {
            return 80
        }
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("mainLabelsA--->",mainLabelsA)
        return mainLabelsA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = PICell(style: .default, reuseIdentifier: "pi_cell")
        
        cell.title.text =  (mainLabelsA.object(at: indexPath.row) as! String)
        cell.accessoryType = .disclosureIndicator
        
        if(indexPath.row == 0)
        {
            cell.image.downloadedFrom(link: (mainDataA.object(at: indexPath.row) as! String))
            cell.image.isHidden = false
            cell.icon.y = 25
        }else{
            cell.value.text =  (mainDataA.object(at: indexPath.row) as! String)
            cell.image.isHidden = true
            cell.icon.y = 15
        }
        
        
        if(indexPath.row == 2)
        {
            cell.value.text = sharedData.formatPhone(with: "XXX XXX XXXX", phone: cell.value.text!)
        }
       
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if(indexPath.row == 0)
        {
            sharedData.edit_key = (mainKeysA.object(at: indexPath.row) as! String)
            sharedData.edit_value = (mainDataA.object(at: indexPath.row) as! String)
            pageEditPhoto.initClass()
            mainCon.addSubview(pageEditPhoto)
            UIView.animate(withDuration: 0.25, animations:
            {
                self.mainCon.x = self.sharedData.screenWidth * -1
            })
        }else{
            sharedData.edit_key = (mainKeysA.object(at: indexPath.row) as! String)
            sharedData.edit_title = (mainLabelsA.object(at: indexPath.row) as! String)
            sharedData.edit_value = (mainDataA.object(at: indexPath.row) as! String)
            
            pageEditItem.initClass()
            mainCon.addSubview(pageEditItem)
          
            
            UIView.animate(withDuration: 0.25, animations:
            {
                self.mainCon.x = self.sharedData.screenWidth * -1
            })
        }
    }
    
    @objc func goBackEdit()
    {
        UIView.animate(withDuration: 0.25, animations:
        {
            self.mainCon.x = 0
        })
        
    }
    
    @objc func goBack()
    {
        sharedData.postEvent(event: "MY_ACCOUNT_HOME")
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
