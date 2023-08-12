//
//  Students.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/10/23.
//



import UIKit

class MyStudents:BasePage, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    var sharedData:SharedData!
    
    var feedList:UITableView!
    
    var mainDataA:NSMutableArray = NSMutableArray()
    
    var mainCon:UIView!
    
    var actInd:UIActivityIndicatorView!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        mainCon = UIView(frame: sharedData.fullRect)
        mainCon.width = sharedData.screenWidth
        addSubview(mainCon)
        
        let topBar = sharedData.getTopBarBig(title: "My Students")
        topBar.addBack(selector: #selector(self.goBack), target: self)
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
        feedList.register(MyAccountCell.self, forCellReuseIdentifier: "mystudents_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
        
        actInd = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.hidesWhenStopped = true
        actInd.center = CGPoint(x: sharedData.screenWidth * 0.5, y: 130)
        actInd.style = .large
        actInd.tintColor = .black
        actInd.startAnimating()
    }
    
    override func initClass()
    {
        loadData()
    }
    
    @objc func loadData()
    {
        mainCon.addSubview(actInd)
        sharedData.getIt(urlString: sharedData.base_domain + "/api-ios/students-list", params: [:], callback:
        {
            success, result_dict in
            
            self.mainDataA.addObjects(from: (result_dict.object(forKey: "result") as! Array<Any>) )
            self.actInd.removeFromSuperview()
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
        let cell = MyAccountCell(style: .default, reuseIdentifier: "mystudents_cell")
        cell.title.font = sharedData.normalFont(size: 20)
            
        cell.accessoryType = .disclosureIndicator
        let data = (mainDataA.object(at: indexPath.row) as! NSDictionary)
        
        cell.title.text = (data.object(forKey: "student_name") as! String)
        cell.image.corner(radius: 20)
        cell.image.downloadedFrom(link: (data.object(forKey: "photo") as! String))
        cell.image.isHidden = false
        cell.image.layer.borderWidth = 1
        cell.image.layer.borderColor = UIColor.lightGray.cgColor
        
            
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        
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
