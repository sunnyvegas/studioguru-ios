//
//  PaymentMethods.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/10/23.
//

import UIKit

class PaymentMethods:BasePage, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
{
    var sharedData:SharedData!
    
    var studioImg:UIImageView!
    var custImg:UIImageView!
    
    var mainCon:UIView!
    
    var feedList:UITableView!
    
    var mainDataA:NSMutableArray = NSMutableArray()
    var iconsA:NSMutableArray = NSMutableArray()
    var actInd:UIActivityIndicatorView!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        
        let topBar = sharedData.getTopBarBig(title: "Payment Methods")
        topBar.addBack(selector: #selector(self.goBack), target: self)
        topBar.addPlus(selector: #selector(self.goAdd), target: self)
        mainCon.addSubview(topBar)
        
        actInd = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.hidesWhenStopped = true
        actInd.center = CGPoint(x: sharedData.screenWidth * 0.5, y: 130)
        actInd.style = .large
        actInd.tintColor = .black
        actInd.startAnimating()
        
        
        feedList = UITableView();
        feedList.width = sharedData.screenWidth
        feedList.y = topBar.posY()
        feedList.height = sharedData.screenHeight - feedList.y
        feedList.backgroundColor = UIColor.clear
        feedList.delegate = self
        feedList.dataSource = self
        feedList.showsVerticalScrollIndicator = false
        feedList.separatorStyle = .none
        feedList.register(PMCell.self, forCellReuseIdentifier: "pm_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
        
        sharedData.addEventListener(title: "RELOAD_PAYMENT_METHODS", target: self, selector: #selector(self.loadData))
    }
    
    override func initClass()
    {
        loadData()
    }
    
    @objc func loadData()
    {
        self.mainDataA.removeAllObjects()
        self.feedList.reloadData()
        mainCon.addSubview(actInd)
        sharedData.getIt(urlString: sharedData.base_domain + "/api-ios/details-payment-methods", params: [:], callback:
        {
            success, result_dict in
            
            self.mainDataA.removeAllObjects()
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
        let cell = PMCell(style: .default, reuseIdentifier: "pm_cell")
        
        let data = (mainDataA.object(at: indexPath.row) as! NSDictionary)
        
       
        //cell.accessoryType = .disclosureIndicator
        cell.title.text = (data.object(forKey: "title") as! String)
        cell.subtitle.text = (data.object(forKey: "type") as! String)
      
        
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
    
    @objc func goAdd()
    {
        let optionMenu = UIAlertController(title: "Select Payment Method Type", message: "", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "Add Credit Card", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
             
            let page = PMAddCreditCard(frame: self.sharedData.fullRectBottom)
            self.mainCon.addSubview(page)
            page.initClass()
            page.animateUp()
           
        })
        optionMenu.addAction(action1)
        
        
        
        let action2 = UIAlertAction(title: "Add Bank Account", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
           
            
            
            let page = PMAddBankAccount(frame: self.sharedData.fullRectBottom)
            self.mainCon.addSubview(page)
            page.initClass()
            page.animateUp()
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        
        })
        
        
        optionMenu.addAction(action2)
        optionMenu.addAction(cancelAction)
        
        self.window?.rootViewController?.present(optionMenu, animated: true, completion: nil)
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
