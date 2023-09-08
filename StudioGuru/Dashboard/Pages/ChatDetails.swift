//
//  ChatDetails.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/19/23.
//

import UIKit
import LocalAuthentication


class ChatDetails:UIView, UITextFieldDelegate, UIScrollViewDelegate
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
    
    var isKeyboardUp:Bool = false
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = UIColor(hex: 0xf5f5f5)
        
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
        bottomCon.height = 60
        
        bottomCon.backgroundColor = UIColor(hex: 0xDDDDDD)
        
        //let device = UIDevice.current
       // let systemVersion = device.systemVersion
        //let deviceName = device.modelName
        let context = LAContext()
        
        var error: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            // Face ID is available on the device
            if context.biometryType == .faceID {
                print("The device has Face ID")
                bottomCon.height = 80
                bottomCon.y = sharedData.screenHeight - bottomCon.height
                
            } else if context.biometryType == .touchID {
                print("The device has Touch ID")
            } else {
                print("The device has some other biometric authentication method")
            }
        } else {
            // Face ID is not available on the device or not configured
            print("Face ID is not available or not configured on this device.")
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
        
       
        //print("sharedData.screenHeight--->",sharedData.screenHeight)
        
        //Optional(896.0)
        
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
        messagesCon.delegate = self
        messagesCon.width = sharedData.screenWidth
        messagesCon.height = sharedData.screenHeight - messagesCon.y - bottomCon.height
        
        mainCon.addSubview(messagesCon)
        mainCon.addSubview(bottomCon)
        
        sharedData.addEventListener(title: "RELOAD_CURRENT_CHAT", target: self, selector: #selector(self.initClass))
    }
    
    @objc func initClass()
    {
        topBar.titleLabel.text = sharedData.chat_title
        
        pplDataA.removeAllObjects()
        messagesDataA.removeAllObjects()
        
        loadData()
    }
    
    @objc func loadData()
    {
        sharedData.getIt(urlString: sharedData.base_domain + "/api-ios/chat/details/" + sharedData.chat_id, params: [:], callback:
        {
            success, result_dict in
            
            let mainDict = (result_dict.object(forKey: "result") as! NSDictionary)
            
            self.pplDataA.addObjects(from: (mainDict.object(forKey: "members") as! Array<Any>) )
            
            self.messagesDataA.addObjects(from: (mainDict.object(forKey: "messages") as! Array<Any>) )
            //pplDataA
            self.renderDetails()
            
            self.sharedData.postEvent(event: "UPDATE_BADGE_COUNT")
        })
    }
    
    @objc func refreshChatBadge()
    {
        //sharedData.chat_label
    }
    
    @objc func renderDetails()
    {
        print("self.pplDataA---->",self.pplDataA)
        
        messagesCon.removeSubViews()
        pplCon.removeSubViews()
        pplCon.backgroundColor = .white
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
                let whiteCon = UIView()
                whiteCon.width = sharedData.screenWidth - 20
                whiteCon.x = 10
                whiteCon.height = 80
                whiteCon.y = 10
                whiteCon.corner(radius: 10)
                whiteCon.backgroundColor = .white
                whiteCon.addDropShadow()
                row_item.addSubview(whiteCon)
                
                let btnImg = UIButton(type: .custom)
                btnImg.width = 60
                btnImg.height = 60
                btnImg.corner(radius: 30)
                btnImg.x = 10
                btnImg.y = 10
                btnImg.layer.borderColor = UIColor.gray.cgColor
                btnImg.layer.borderWidth = 1
                btnImg.backgroundColor = .darkGray
                btnImg.downloadedFrom(link: sharedData.base_domain + "/member-photo/" + member_id)
                whiteCon.addSubview(btnImg)
                
                let nameLabel = UILabel()
                nameLabel.width = whiteCon.width - btnImg.posX() - 10
                nameLabel.height = 20
                nameLabel.font = .systemFont(ofSize: 16, weight: .bold)
                nameLabel.textColor = .black
                nameLabel.x = btnImg.posX() + 10
                nameLabel.y = 10
                nameLabel.text = (messageData.object(forKey: "member_name") as! String)
                whiteCon.addSubview(nameLabel)
                
                let messageCon = UITextView()
                messageCon.width = sharedData.screenWidth - btnImg.posX() - 50
                messageCon.height = 80
                messageCon.x = btnImg.posX()
                messageCon.y = nameLabel.posY()
                messageCon.corner(radius: 10)
                messageCon.backgroundColor = UIColor(hex: 0xFFFFFF)
                messageCon.textColor = .black
                messageCon.font = .systemFont(ofSize: 16)
                messageCon.text = (messageData.object(forKey: "message") as! String)
                messageCon.isUserInteractionEnabled = false
                messageCon.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
                messageCon.sizeToFit()
                whiteCon.addSubview(messageCon)
                
                
                
                
                let dateLabel = UILabel()
                dateLabel.width = whiteCon.width - 10
                dateLabel.height = 15
                dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
                dateLabel.textColor = .darkGray
                dateLabel.alpha = 0.5
                dateLabel.text = ""
                dateLabel.y = 10
                dateLabel.textAlignment = .right
                whiteCon.addSubview(dateLabel)
                
                let date = (messageData.object(forKey: "created_at") as! String).mongoDate
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MM/dd hh:mm a" // "12/16 12:00 PM"
                let formattedDate = outputFormatter.string(from: date)
                dateLabel.text = formattedDate

                whiteCon.height = messageCon.posY() + 10
                row_item.height = whiteCon.posY() + 10
                lastY = row_item.posY() + 5
            }else{
                
                let dateLabel = UILabel()
                dateLabel.width = sharedData.screenWidth - 10
                dateLabel.height = 15
                dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
                dateLabel.textColor = UIColor(hex: 0x000000)
                dateLabel.alpha = 0.5
                dateLabel.text = ""
                dateLabel.textAlignment = .right
                dateLabel.y = 10
                row_item.addSubview(dateLabel)
                
                let date = (messageData.object(forKey: "created_at") as! String).mongoDate
                let outputFormatter = DateFormatter()
                outputFormatter.dateFormat = "MM/dd hh:mm a" // "12/16 12:00 PM"
                let formattedDate = outputFormatter.string(from: date)
                dateLabel.text = formattedDate
                
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
        isKeyboardUp = true
        
        if(sharedData.keyboardHeight == 0)
        {
            sharedData.setTimeout(delay: 1.0, block: {
                self.messagesCon.height = self.sharedData.screenHeight - self.messagesCon.y - self.bottomCon.height - (self.sharedData.keyboardHeight )
                UIView.animate(withDuration: 0.25)
                {
                    self.bottomCon.y = self.sharedData.screenHeight - self.sharedData.keyboardHeight - self.bottomCon.height
                }
                
                let contentHeight = self.messagesCon.contentSize.height
                let bottomOffset = CGPoint(x: 0, y: contentHeight - self.messagesCon.bounds.size.height)
                self.messagesCon.setContentOffset(bottomOffset, animated: true)
            })
        }else{
            messagesCon.height = sharedData.screenHeight - messagesCon.y - bottomCon.height - (sharedData.keyboardHeight)
            UIView.animate(withDuration: 0.25)
            {
                self.bottomCon.y = self.sharedData.screenHeight - self.sharedData.keyboardHeight - self.bottomCon.height
            }
            
            let contentHeight = messagesCon.contentSize.height
            let bottomOffset = CGPoint(x: 0, y: contentHeight - messagesCon.bounds.size.height)
            messagesCon.setContentOffset(bottomOffset, animated: true)
        }
        
        
            return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        let currentDate = Date()

        // Create an ISO8601DateFormatter
        let isoFormatter = ISO8601DateFormatter()

        // Optionally, you can set formatting options for the ISO8601 string
        isoFormatter.formatOptions = [.withInternetDateTime]

        // Convert the Date object to an ISO8601 string
        let isoString = isoFormatter.string(from: currentDate)
        
        let data = NSMutableDictionary()
        data.setValue(sharedData.member_id, forKey: "member_id")
        data.setValue(sharedData.member_name, forKey: "member_name")
        data.setValue(input.text, forKey: "message")
        data.setValue(isoString, forKey: "created_at")
        
        messagesDataA.add(data)
        renderDetails()
        input.text = ""
        let contentHeight = messagesCon.contentSize.height
        let bottomOffset = CGPoint(x: 0, y: contentHeight - messagesCon.bounds.size.height)
        messagesCon.setContentOffset(bottomOffset, animated: true)
        
        sharedData.postIt(urlString: sharedData.base_domain + "/api-ios/chat/details-add/" + sharedData.chat_id , params: data as! [String : Any], callback: {
            success, result_dict in
            
            
            
            
        })
        
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
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
       
        
        let contentOffsetY = scrollView.contentOffset.y
        
        if(isKeyboardUp == true)
        {
            if scrollView.contentOffset.y > 0
            {
                // Scrolling down
                
                //print("Y---",contentOffsetY, "-", scrollView.contentSize.height)
                if(contentOffsetY + 600 < scrollView.contentSize.height)
                {
                    print("Scrolling down")
                    isKeyboardUp = false
                    input.resignFirstResponder()
                    input.text = ""
                    messagesCon.height = sharedData.screenHeight - messagesCon.y - bottomCon.height
                    UIView.animate(withDuration: 0.01)
                    {
                        self.bottomCon.y = self.sharedData.screenHeight -  self.bottomCon.height
                    }
                }
            }
        }
        
        
    }
    
    @objc func goSetting()
    {
        
        let optionMenu = UIAlertController(title: "Select Option", message: "", preferredStyle: .actionSheet)
        
        let libAction = UIAlertAction(title: "Report Issue", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
          
            
            self.sharedData.email_message = "I would like to report an issue in the " + self.sharedData.chat_title + " Group Chat"
            self.sharedData.email_subject = "Report Issue In Group Chat"
            self.sharedData.postEvent(event: "SHOW_EMAIL")
           
        })
        optionMenu.addAction(libAction)
        
        
      
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        
        })
        
        
     
        optionMenu.addAction(cancelAction)
        
        self.window?.rootViewController?.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func goBack()
    {
        isKeyboardUp = false
        input.resignFirstResponder()
        input.text = ""
        sharedData.chat_id = ""
        messagesCon.height = sharedData.screenHeight - messagesCon.y - bottomCon.height
        UIView.animate(withDuration: 0.01)
        {
            self.bottomCon.y = self.sharedData.screenHeight -  self.bottomCon.height
        }
        sharedData.postEvent(event: "CHAT_HOME")
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
