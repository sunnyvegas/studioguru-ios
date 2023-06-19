//
//  ChatDetails.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/19/23.
//

import UIKit


class ChatDetails:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var topBar:TopBar!
    
    var mainCon:UIView!
    
    var pplCon:UIScrollView!
    
    var pplDataA:NSMutableArray = NSMutableArray()
    var messagesDataA:NSMutableArray = NSMutableArray()
    
    var messagesCon:UIScrollView!
    
    var bottomCon:UIView!
    
    var input:UITextField!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        topBar = sharedData.getTopBarBig(title: "")
        topBar.addBack(selector: #selector(self.goBack), target: self)
        topBar.addSetting(selector: #selector(self.goSetting), target: self)
        addSubview(topBar)
        
        pplCon = UIScrollView()
        pplCon.width = sharedData.screenWidth
        pplCon.height = 60
        pplCon.y = topBar.posY()
        mainCon.addSubview(pplCon)
        
        let line = UIView()
        line.width = sharedData.screenWidth
        line.height = 1
        line.backgroundColor = .gray
        line.y = pplCon.posY()
        mainCon.addSubview(line)
        
        
        bottomCon = UIView()
        bottomCon.width = sharedData.screenWidth
        bottomCon.height = 120
        bottomCon.y = sharedData.screenHeight - bottomCon.height
        bottomCon.backgroundColor = UIColor(hex: 0xDDDDDD)
        
        
        input = UITextField()
        input.width = sharedData.screenWidth - 20
        input.height = 40
        input.x = 10
        input.corner(radius: 10)
        input.paddingLeft(10)
        input.backgroundColor = .white
        input.returnKeyType = .send
        input.delegate = self
        input.y = 10
        bottomCon.addSubview(input)
        
        messagesCon = UIScrollView()
        messagesCon.y = line.posY()
        messagesCon.width = sharedData.screenWidth
        messagesCon.height = sharedData.screenHeight - messagesCon.y - bottomCon.height
        
        mainCon.addSubview(messagesCon)
        mainCon.addSubview(bottomCon)
    }
    
    func initClass()
    {
        topBar.titleLabel.text = sharedData.chat_title
        
        pplDataA.removeAllObjects()
        messagesDataA.removeAllObjects()
        
        loadData()
    }
    
    @objc func loadData()
    {
        sharedData.getIt(urlString: sharedData.base_domain + "/api-member/chat/details/" + sharedData.chat_id, params: [:], callback:
        {
            success, result_dict in
            
            let mainDict = (result_dict.object(forKey: "result") as! NSDictionary)
            
            self.pplDataA.addObjects(from: (mainDict.object(forKey: "members") as! Array<Any>) )
            
            self.messagesDataA.addObjects(from: (mainDict.object(forKey: "messages") as! Array<Any>) )
            //pplDataA
            self.renderDetails()
        })
    }
    
    @objc func renderDetails()
    {
        print("self.pplDataA---->",self.pplDataA)
        
        messagesCon.removeSubViews()
        pplCon.removeSubViews()
        if(CGFloat(pplDataA.count) * 60 < sharedData.screenWidth)
        {
            pplCon.contentSize = CGSize(width: sharedData.screenWidth, height: 60)
        }else{
            pplCon.contentSize = CGSize(width: (CGFloat(pplDataA.count) * 60), height: 60)
        }
        
        for i in 0..<pplDataA.count
        {
            let data = (pplDataA.object(at: i) as! NSDictionary)
            let row_item = UIButton(type: .custom)
            row_item.width = 40
            row_item.height = 40
            row_item.y = 10
            row_item.corner(radius: 20)
            row_item.downloadedFrom(link: sharedData.base_domain + "/member-photo/" + (data.object(forKey: "member_id") as! String) )
            row_item.x = 10 + (CGFloat(i) * 50)
            pplCon.addSubview(row_item)
        }
        var lastY:CGFloat = 0
        for i in 0..<messagesDataA.count
        {
            let messageData = (messagesDataA.object(at: i) as! NSDictionary)
            let member_id = (messageData.object(forKey: "member_id") as! String)
            let row_item = UIView()
            row_item.width = sharedData.screenWidth
            row_item.height = 100
            row_item.y = lastY
            if(member_id != sharedData.member_id)
            {
                let btnImg = UIButton(type: .custom)
                btnImg.width = 30
                btnImg.height = 30
                btnImg.corner(radius: 15)
                btnImg.x = 10
                btnImg.y = 10
                btnImg.backgroundColor = .darkGray
                btnImg.downloadedFrom(link: sharedData.base_domain + "/member-photo/" + member_id)
                row_item.addSubview(btnImg)
                
                let dateLabel = UILabel()
                dateLabel.width = sharedData.screenWidth - 10
                dateLabel.height = 15
                dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
                dateLabel.textColor = UIColor(hex: 0x000000)
                dateLabel.alpha = 0.5
                dateLabel.text = (messageData.object(forKey: "member_name") as! String) + " 12/16 12:00 PM"
                dateLabel.x = btnImg.posX() + 10
                dateLabel.y = 10
                row_item.addSubview(dateLabel)
                
                let messageCon = UITextView()
                messageCon.width = sharedData.screenWidth - btnImg.posX() - 50
                messageCon.height = 80
                messageCon.x = btnImg.posX() + 10
                messageCon.y = dateLabel.posY()
                messageCon.corner(radius: 10)
                messageCon.backgroundColor = UIColor(hex: 0xEEEEEE)
                messageCon.textColor = .black
                messageCon.font = .systemFont(ofSize: 16)
                messageCon.text = (messageData.object(forKey: "message") as! String)
                messageCon.isUserInteractionEnabled = false
                messageCon.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                messageCon.sizeToFit()
                row_item.addSubview(messageCon)
                
                row_item.height = messageCon.posY()
                
                lastY = row_item.posY() + 5
            }else{
                
                let dateLabel = UILabel()
                dateLabel.width = sharedData.screenWidth - 10
                dateLabel.height = 15
                dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
                dateLabel.textColor = UIColor(hex: 0x000000)
                dateLabel.alpha = 0.5
                dateLabel.text = "12/16 12:00 PM"
                dateLabel.textAlignment = .right
                dateLabel.y = 10
                row_item.addSubview(dateLabel)
                
                let messageCon = UITextView()
                messageCon.width = sharedData.screenWidth  - 90
                messageCon.height = 100
                messageCon.x = 80
                messageCon.y = 25
                messageCon.isUserInteractionEnabled = false
                messageCon.corner(radius: 10)
                messageCon.backgroundColor = UIColor(hex: 0x2f90f7)
                messageCon.textColor = .white
                messageCon.font = .systemFont(ofSize: 16)
                messageCon.text = (messageData.object(forKey: "message") as! String)
                messageCon.isUserInteractionEnabled = false
                messageCon.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                messageCon.sizeToFit()
                messageCon.x = sharedData.screenWidth - messageCon.width - 10
                row_item.addSubview(messageCon)
                
                row_item.height = messageCon.posY()
                
                lastY = row_item.posY() + 5
            }
            
            messagesCon.addSubview(row_item)
        }
        
        messagesCon.contentSize = CGSize(width: sharedData.screenWidth, height: lastY + 20)
        
        let contentHeight = messagesCon.contentSize.height
        let bottomOffset = CGPoint(x: 0, y: contentHeight - messagesCon.bounds.size.height)
        messagesCon.setContentOffset(bottomOffset, animated: false)
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
            // Perform actions when the keyboard is about to be shown
            print("Keyboard will show")
            
        messagesCon.height = sharedData.screenHeight - messagesCon.y - bottomCon.height - (400 - bottomCon.height)
        UIView.animate(withDuration: 0.25)
        {
            self.bottomCon.y = self.sharedData.screenHeight - 400
        }
        
        let contentHeight = messagesCon.contentSize.height
        let bottomOffset = CGPoint(x: 0, y: contentHeight - messagesCon.bounds.size.height)
        messagesCon.setContentOffset(bottomOffset, animated: true)
            return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let data = NSMutableDictionary()
        data.setValue(sharedData.member_id, forKey: "member_id")
        data.setValue(input.text, forKey: "message")
        
        messagesDataA.add(data)
        renderDetails()
        input.text = ""
        let contentHeight = messagesCon.contentSize.height
        let bottomOffset = CGPoint(x: 0, y: contentHeight - messagesCon.bounds.size.height)
        messagesCon.setContentOffset(bottomOffset, animated: true)
        /*
        input.resignFirstResponder()
        input.text = ""
        messagesCon.height = sharedData.screenHeight - messagesCon.y - bottomCon.height
        UIView.animate(withDuration: 0.25)
        {
            self.bottomCon.y = self.sharedData.screenHeight -  self.bottomCon.height
        }
        */
        
        return true
    }
    
    @objc func goSetting()
    {
        
    }
    
    @objc func goBack()
    {
        sharedData.postEvent(event: "GO_BACK_CHAT")
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
