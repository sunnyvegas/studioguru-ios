//
//  Login.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//


import UIKit

class Login:UIView, UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource, UNUserNotificationCenterDelegate
{
    
    var sharedData:SharedData!
    var inputEmail:UITextField!
    var inputPass:UITextField!
    var inputStudios:UITextField!
    var btnLogin:UIButton!
    var mainCon:UIView!
    var mainDataA:NSMutableArray = NSMutableArray()
    var mainPicker:UIPickerView!
    
    var card:UIView!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        let mainLogo = UIImageView()
        mainLogo.width = sharedData.screenWidth * 0.8
        mainLogo.height = mainLogo.width/2
        mainLogo.x = sharedData.screenWidth/2 - mainLogo.width/2
        mainLogo.y = 100
        mainLogo.image = UIImage(named: "kiwi_logo_square")
        mainLogo.contentMode = .scaleAspectFit
        addSubview(mainLogo)
        
        
        mainPicker = UIPickerView()
        mainPicker.frame = CGRect(x: 0, y: 0, width: sharedData.screenWidth, height: 180)
        mainPicker.delegate = self
        mainPicker.dataSource = self
       
        let padding:CGFloat = 20
        
        inputEmail = UITextField()
        inputEmail.width = sharedData.screenWidth - (padding * 2)
        inputEmail.backgroundColor = .white
        inputEmail.x = padding
        inputEmail.y = mainLogo.posY() + 10
        inputEmail.keyboardType = .emailAddress
        inputEmail.returnKeyType = .next
        inputEmail.autocorrectionType = .no
        inputEmail.autocapitalizationType = .none
        inputEmail.height = 50
        inputEmail.borderStyle = .roundedRect
        inputEmail.paddingLeft(10)
        inputEmail.delegate = self
        //inputEmail.corner(radius: 10)
        addSubview(inputEmail)
        
        
        let labelEmail = UILabel()
        labelEmail.text = "Email"
        labelEmail.textColor = .black
        labelEmail.x = padding
        labelEmail.width = 200
        labelEmail.height = 20
        labelEmail.y = inputEmail.y - 20
        labelEmail.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        addSubview(labelEmail)
        
        
        inputPass = UITextField()
        inputPass.width = inputEmail.width
        inputPass.x = padding
        inputPass.y = inputEmail.posY() + 40
        inputPass.height = 50
        inputPass.delegate = self
        inputPass.paddingLeft(10)
        inputPass.returnKeyType = UIReturnKeyType.next
        inputPass.backgroundColor = .white
        inputPass.isSecureTextEntry = true
        inputPass.borderStyle = .roundedRect
        addSubview(inputPass)
        
        
        let labelPass = UILabel()
        labelPass.text = "Password"
        labelPass.textColor = .black
        labelPass.x = padding
        labelPass.y = inputPass.y - 20
        labelPass.width = 200
        labelPass.height = 20
        labelPass.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        addSubview(labelPass)
        
        let labelStudio = UILabel()
        labelStudio.text = "Studio"
        labelStudio.textColor = .black
        labelStudio.x = padding
        labelStudio.y = inputPass.posY() + 20
        labelStudio.width = 200
        labelStudio.height = 20
        labelStudio.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        addSubview(labelStudio)
        
        
        inputStudios = UITextField()
        inputStudios.width = sharedData.screenWidth - (padding * 2)
        inputStudios.backgroundColor = .white
        inputStudios.x = padding
        inputStudios.y = labelStudio.posY() + 10
        inputStudios.returnKeyType = .done
        inputStudios.autocorrectionType = .no
        inputStudios.autocapitalizationType = .none
        inputStudios.height = 50
        inputStudios.borderStyle = .roundedRect
        inputStudios.paddingLeft(10)
        inputStudios.delegate = self
        inputStudios.inputView = mainPicker
        inputStudios.placeholder = "Select Studio"
        
        let toolbar = sharedData.getToolBar(target: self, selector: #selector(self.hidePicker), title: "Done", direction: "right")
        inputStudios.inputAccessoryView = toolbar
        //inputEmail.corner(radius: 10)
        addSubview(inputStudios)
        
        //006cab
        
        btnLogin = UIButton(type: .custom)
        btnLogin.y = inputStudios.posY() + 20
        btnLogin.x = padding
        btnLogin.width = inputEmail.width
        btnLogin.height = 50
        btnLogin.corner(radius: 5)
        btnLogin.setTitle("LOGIN", for: .normal)
        btnLogin.setTitleColor(UIColor.white, for: .normal)
        btnLogin.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btnLogin.backgroundColor = sharedData.blue
        btnLogin.addEventListener(selector: #selector(self.goLogin), target: self)
        //btnLogin.alpha = 0.5
        addSubview(btnLogin)
        
        let btnSignUp = UIButton(type: .custom)
        btnSignUp.y = btnLogin.posY() + 40
        btnSignUp.x = padding
        btnSignUp.width = inputEmail.width
        btnSignUp.height = 30
        btnSignUp.corner(radius: 5)
        btnSignUp.setTitle("Sign Up", for: .normal)
        btnSignUp.setTitleColor(sharedData.blue, for: .normal)
        btnSignUp.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        btnSignUp.setUnderline(text: "Sign Up", color: sharedData.blue)
        //btnSignUp.backgroundColor = UIColor(hex: 0x006CAB)
        btnSignUp.addEventListener(selector: #selector(self.goSignUp), target: self)
        //btnLogin.alpha = 0.5
        addSubview(btnSignUp)
        
        sharedData.addEventListener(title: "LOG_OUT", target: self, selector: #selector(self.onLogOut))
        
        sharedData.addEventListener(title: "TOKEN_LOADED", target: self, selector: #selector(self.tokenLoaded))
        sharedData.postEvent(event: "SHOW_LOADING")
       
        sharedData.setTimeout(delay: 0.5, block: {
            if(self.sharedData.is_online == true)
            {
                self.loadData()
            }
        })
        
        
        
    }
    
    func initClass()
    {
    
    }
    
    @objc func onLogOut()
    {
        inputEmail.text = ""
        inputPass.text = ""
        inputStudios.text = ""
    }
    
    @objc func loadData()
    {
        //print("---->","http://" + sharedData.domain + ":3400/api-studios")
        sharedData.getIt(urlString:"https://www.test-kiwisuites.com/api-studios", params: [:], callback:
        {
            success, result_dict in
            
            self.mainDataA.addObjects(from: (result_dict.object(forKey: "result") as! Array<Any>) )
            self.sharedData.studio_id = ((self.mainDataA.object(at: 0) as! NSDictionary).object(forKey: "id") as! String)
            self.mainPicker.reloadAllComponents()
            print("mainDataA--->",result_dict)
            self.sharedData.setTimeout(delay: 0.15, block: {
               self.checkLogin()
            })
        })
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int
    {
       return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        mainDataA.count
    }
    
    @objc func hidePicker()
    {
        print("hidePicker!")
        
        inputStudios.resignFirstResponder()
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        
//        if(row == 1)
//        {
//            return "Unspecified"
//        }
        
        return ((mainDataA.object(at: row) as! NSDictionary).object(forKey: "text") as! String)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        // use the row to get the selected row from the picker view
        // using the row extract the value from your datasource (array[row])
        
//        if(row == 1)
//        {
//            main_input.text =  "Unspecified"
//            return
//        }
//
        inputStudios.text = ((mainDataA.object(at: row) as! NSDictionary).object(forKey: "text") as! String)
        print("updated!!")
    }
    
    @objc func updateLoginFromSignUp()
    {
        inputEmail.text = sharedData.s_email
        inputPass.text = sharedData.s_password
        
        sharedData.setTimeout(delay: 0.5, block: {
            self.goLogin()
        })
    }
    
    @objc func tokenLoaded()
    {
        print("tokenLoaded--->")
        if(sharedData.getUserData(title: "user_email") != "")
        {
            inputEmail.text = sharedData.getUserData(title: "user_email")
            inputPass.text = sharedData.getUserData(title: "user_pass")
            inputStudios.text = sharedData.getUserData(title: "studio_id")
            if(mainDataA.count > 0)
            {
                self.goLogin()
            }
            //self.goLogin()
        }else{
            sharedData.postEvent(event: "HIDE_LOADING")
        }
    }
    
    func checkLogin()
    {
        
        self.sharedData.setTimeout(delay: 1.0, block: {
            
            //self.checkGulpTimer()
            
            
            let center = UNUserNotificationCenter.current()
            // Set the delegate to handle notification actions.
            center.delegate = self
                center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                  // Enable or disable features based on authorization.
                    DispatchQueue.main.async {
                               UIApplication.shared.registerForRemoteNotifications()
                               }
                   print("Enabled!")
                }
                
               
        })
       /*
        if(sharedData.getUserData(title: "user_email") != "")
        {
            inputEmail.text = sharedData.getUserData(title: "user_email")
            inputPass.text = sharedData.getUserData(title: "user_pass")
            inputStudios.text = sharedData.getUserData(title: "studio_id")
            self.goLogin()
        }
        */
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      // Convert the device token to a string.
      let token = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
      
        
        SharedData.sharedInstance.device_token = token
      // Print the device token to the console.
      print("Device token-: \(token)")
        
    
       
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
           // Check if the notification contains a JSON payload
        print("RECIEVE_NOTIFICATION2")
        //SharedData.sharedInstance.showMessage(title: "Alert", message: "Received Notification2")
        if let userInfo = response.notification.request.content.userInfo as? [String: Any]
        {
               // Handle the JSON payload here
               print("Received notification with payload: \(userInfo)")
            
            if let type = userInfo["type"] as? String
            {
                       //do something with url here
                print("type---->",type)
                
                if(SharedData.sharedInstance.member_id == "")
                {
                    return
                }
                
                if(type == "chat")
                {
                    let chat_id = userInfo["chat_id"] as! String
                    
                    if(chat_id == SharedData.sharedInstance.chat_id)
                    {
                        SharedData.sharedInstance.postEvent(event: "RELOAD_CURRENT_CHAT")
                    }else{
                        SharedData.sharedInstance.tmp_chat_id = chat_id
                        SharedData.sharedInstance.tmp_chat_title = userInfo["chat_name"] as! String
                        SharedData.sharedInstance.postEvent(event: "UPDATE_BADGE_COUNT")
                        SharedData.sharedInstance.postEvent(event: "SHOW_CHAT_BANNER")
                        SharedData.sharedInstance.checkChatCount()
                    }
                }
                
               // SharedData.sharedInstance.showMessage(title: "Alert", message: "Type")
                }
            
        }
        
        
        
        
        
           // Call the completion handler when done
           completionHandler()
       }
    
   
    @objc func goLogin()
    {
        if(inputStudios.text == "")
        {
            sharedData.showMessage(title: "Error", message: "Please select a studio to login with")
            return
        }
        
        if(mainDataA.count == 0)
        {
            self.loadData()
            return
        }
        
        inputPass.resignFirstResponder()
        inputEmail.resignFirstResponder()
        inputStudios.resignFirstResponder()
        
        sharedData.postEvent(event: "SHOW_LOADING")
        print("mainDataA->",mainDataA)
        print("mainPicker.selectedRow(inComponent: 0)--->",mainPicker.selectedRow(inComponent: 0))
        sharedData.studio_id = ((mainDataA.object(at: mainPicker.selectedRow(inComponent: 0)) as! NSDictionary).object(forKey: "id") as! String)
        sharedData.studio_name = ((mainDataA.object(at: mainPicker.selectedRow(inComponent: 0)) as! NSDictionary).object(forKey: "text") as! String)
        
        sharedData.base_domain = "https://www.test-kiwisuites.com" +  "/studio/" + sharedData.studio_id//"https://dev-studiobossapp.herokuapp.com" +  "/studio/" + sharedData.studio_id
        
        
        print(sharedData.base_domain + "/api-login-ios")
        sharedData.postIt(urlString: sharedData.base_domain + "/api-login-ios", params: ["email":inputEmail.text!, "password":inputPass.text!], callback: {
            success, result_dict in
            
            self.sharedData.postEvent(event: "HIDE_LOADING")
            
            if((result_dict.object(forKey: "success") as! Bool) == true)
            {
                //let result = (result_dict.object(forKey: "result") as! NSDictionary)
                
                self.sharedData.setUserData(key: "user_email", value: self.inputEmail.text!)
                self.sharedData.setUserData(key: "user_pass", value: self.inputPass.text!)
                self.sharedData.setUserData(key: "studio_id", value: self.inputStudios.text!)
                
                
                self.inputPass.text = ""
                self.inputEmail.text = ""
                self.inputStudios.text = ""
                
                self.sharedData.support_email = (result_dict.object(forKey: "support_email") as! String)
                self.sharedData.chat_badge_count = (result_dict.object(forKey: "chat_badge_count") as! String)
                self.sharedData.member_id = (result_dict.object(forKey: "member_id") as! String)
                self.sharedData.member_token = (result_dict.object(forKey: "member_token") as! String)
                self.sharedData.member_name = (result_dict.object(forKey: "member_name") as! String)
                
                //feed_badge_count
                self.sharedData.feed_badge_count = (result_dict.object(forKey: "feed_badge_count") as! String)
                
                UIApplication.shared.applicationIconBadgeNumber = (Int(self.sharedData.chat_badge_count)! + Int(self.sharedData.feed_badge_count )!)  
                
                print("UIApplication.shared.applicationIconBadgeNumber--->",UIApplication.shared.applicationIconBadgeNumber)
                
                self.sharedData.owner = (result_dict.object(forKey: "owner") as! Bool)
                self.sharedData.manager = (result_dict.object(forKey: "manager") as! Bool)
                self.sharedData.instructor = (result_dict.object(forKey: "instructor") as! Bool)
                self.sharedData.staff = (result_dict.object(forKey: "staff") as! Bool)
                
                
                print("LOGIN_RESPONSE")
                print(result_dict)
                self.sharedData.postEvent(event: "APP_LOADED")
                self.sharedData.postEvent(event: "SHOW_DASHBOARD")
                //self.sharedData.showMessage(title: "Alert", message: "Success!")
            }else{
                self.sharedData.showMessage(title: "Error", message: (result_dict.object(forKey: "error_message") as! String))
            }
            
        })
        
        ///api-app-login
        
//        sharedData.login_count = sharedData.login_count + 1
//
//
//        inputEmail.resignFirstResponder()
//        inputPass.resignFirstResponder()
//        if(inputEmail.text == "martin")
//        {
//            sharedData.member_id = "martin"
//            sharedData.postEvent(event: "LOAD_DASHBOARD")
//            inputEmail.text = ""
//        }else  if(inputEmail.text == "sunny")
//        {
//            sharedData.member_id = "sunny"
//            sharedData.postEvent(event: "LOAD_DASHBOARD")
//            inputEmail.text = ""
//        }else{
//            sharedData.showMessage(title: "Alert", message: "Invalid email or password")
//        }
    }
    
    @objc func goSignUp()
    {
        sharedData.base_domain = "https://www.test-kiwisuites.com" +  "/studio/" + sharedData.studio_id
        let page = SignUp(frame: sharedData.fullRectBottom)
        page.initClass()
        addSubview(page)
        page.animateUp()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        if(textField == inputEmail)
        {
            inputEmail.resignFirstResponder()
            inputPass.becomeFirstResponder()
        }
        
        if(textField == inputPass)
        {
            inputPass.resignFirstResponder()
         
        }
      
        return true
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
