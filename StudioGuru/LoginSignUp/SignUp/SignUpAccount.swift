//
//  SignUpAccount.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/13/23.
//

import UIKit

class SignUpAccount:BasePage, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    
    var input1:UITextField!
    var input2:UITextField!
    var input3:UITextField!
    
   override init (frame : CGRect)
   {
       super.init(frame : frame)
       sharedData = SharedData.sharedInstance
       backgroundColor = .white
       
       mainCon = UIView(frame: sharedData.fullRect)
       addSubview(mainCon)
       
       let topBar = sharedData.getTopBarBig(title: "Info")
       topBar.addBack(selector: #selector(self.goPrev), target: self)
       addSubview(topBar)
   }
    
    override func initClass()
    {
        renderDetails()
    }
    
    @objc func renderDetails()
    {
        mainCon.removeSubViews()
        
        let padding:CGFloat = 20
        
        let label1 = UILabel()
        label1.text = "Email"
        label1.textColor = .black
        label1.x = padding
        label1.width = 200
        label1.height = 20
        label1.y = 110
        label1.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        mainCon.addSubview(label1)
        
        input1 = UITextField()
        input1.width = sharedData.screenWidth - (padding * 2)
        input1.backgroundColor = .white
        input1.x = padding
        input1.y = label1.posY() + 10
        input1.returnKeyType = .next
        input1.keyboardType = .emailAddress
        input1.height = 50
        input1.autocapitalizationType = .none
        input1.borderStyle = .roundedRect
        input1.paddingLeft(10)
        input1.delegate = self
        input1.text = ""
        mainCon.addSubview(input1)
        
        let label2 = UILabel()
        label2.text = "Password"
        label2.textColor = .black
        label2.x = padding
        label2.width = 200
        label2.height = 20
        label2.y = input1.posY() + 20
        label2.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        mainCon.addSubview(label2)
        
        input2 = UITextField()
        input2.width = sharedData.screenWidth - (padding * 2)
        input2.backgroundColor = .white
        input2.x = padding
        input2.y = label2.posY() + 10
        input2.returnKeyType = .next
        input2.height = 50
        input2.borderStyle = .roundedRect
        input2.paddingLeft(10)
        input2.delegate = self
        input2.isSecureTextEntry = true
        mainCon.addSubview(input2)
        
        
        let label3 = UILabel()
        label3.text = "Confirm Password"
        label3.textColor = .black
        label3.x = padding
        label3.width = 200
        label3.height = 20
        label3.y = input2.posY() + 20
        label3.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        mainCon.addSubview(label3)
        
        input3 = UITextField()
        input3.width = sharedData.screenWidth - (padding * 2)
        input3.backgroundColor = .white
        input3.x = padding
        input3.y = label3.posY() + 10
        input3.returnKeyType = .next
        input3.height = 50
        input3.borderStyle = .roundedRect
        input3.paddingLeft(10)
        input3.delegate = self
        input3.isSecureTextEntry = true
        mainCon.addSubview(input3)
        
   
        
        let btn = sharedData.getBtnNext(title: "NEXT")
        btn.addEventListener(selector: #selector(self.goNext), target: self)
        btn.y = input3.posY() + 20
        mainCon.addSubview(btn)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        if(textField == input1)
        {
            input2.becomeFirstResponder()
        }
        
        if(textField == input2)
        {
            input3.becomeFirstResponder()
        }
        
        return true
    }
    
    @objc func hideKeyboard()
    {
        input1.resignFirstResponder()
        input2.resignFirstResponder()
        input3.resignFirstResponder()
    }
    
    @objc func goPrev()
    {
        hideKeyboard()
        sharedData.cSignUpPage = 1
        sharedData.postEvent(event: "SIGNUP_UPDATE_PAGES")
    }
    
    @objc func goNext()
    {
        hideKeyboard()
        
        let email = input1.text!
        let password = input2.text!
        let c_password = input3.text!
        if(email == "" || password == "" || c_password == "")
        {
            sharedData.showMessage(title: "Error", message: "Please input all fields.")
            return
        }
        
        if(sharedData.isValidEmail(email) == false)
        {
            sharedData.showMessage(title: "Error", message: "Please input valid email address.")
            return
        }
        
        if(password.count < 8)
        {
            sharedData.showMessage(title: "Error", message: "Password needs to be at least 8 characters long.")
            return
        }
        
        if(password != c_password)
        {
            sharedData.showMessage(title: "Error", message: "Password and Confirm Password must match.")
            return
        }
        
        sharedData.s_email = email
        sharedData.s_password = password
        
        sharedData.cSignUpPage = 3
        sharedData.postEvent(event: "SIGNUP_UPDATE_PAGES")
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
