//
//  Login.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//


import UIKit

class Login:UIView, UITextFieldDelegate
{
    
    var sharedData:SharedData!
    var inputEmail:UITextField!
    var inputPass:UITextField!
    var btnLogin:UIButton!
    var mainCon:UIView!
    
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
        mainLogo.image = UIImage(named: "main_logo")
        mainLogo.contentMode = .scaleAspectFit
        addSubview(mainLogo)
        
       
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
        
        //006cab
        
        btnLogin = UIButton(type: .custom)
        btnLogin.y = inputPass.posY() + 20
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
        
        sharedData.setTimeout(delay: 0.5, block: {
            self.checkLogin()
        })
    }
    
    func initClass()
    {
    
    }
    
    @objc func updateLoginFromSignUp()
    {
        inputEmail.text = sharedData.s_email
        inputPass.text = sharedData.s_password
        
        sharedData.setTimeout(delay: 0.5, block: {
            self.goLogin()
        })
    }
    
    func checkLogin()
    {
       
        if(sharedData.getUserData(title: "user_email") != "")
        {
            inputEmail.text = sharedData.getUserData(title: "user_email")
            inputPass.text = sharedData.getUserData(title: "user_pass")
            self.goLogin()
        }
    }
    
    @objc func loadStudios()
    {
        ///api-studios
    }
    
    @objc func goLogin()
    {
        
        inputPass.resignFirstResponder()
        inputEmail.resignFirstResponder()
        
        sharedData.postEvent(event: "SHOW_LOADING")
        
        
        
        
        sharedData.postIt(urlString: sharedData.base_domain + "/api-login", params: ["email":inputEmail.text!, "password":inputPass.text!], callback: {
            success, result_dict in
            
            self.sharedData.postEvent(event: "HIDE_LOADING")
            
            if((result_dict.object(forKey: "success") as! Bool) == true)
            {
                //let result = (result_dict.object(forKey: "result") as! NSDictionary)
                
                self.sharedData.setUserData(key: "user_email", value: self.inputEmail.text!)
                self.sharedData.setUserData(key: "user_pass", value: self.inputPass.text!)
                
                
                self.inputPass.text = ""
                self.inputEmail.text = ""
                
                
                
                self.sharedData.member_id = (result_dict.object(forKey: "member_id") as! String)
                self.sharedData.member_token = (result_dict.object(forKey: "member_token") as! String)
                
                print("LOGIN_RESPONSE")
                print(result_dict)
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
        let page = SignUp(frame: sharedData.fullRectBottom)
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
