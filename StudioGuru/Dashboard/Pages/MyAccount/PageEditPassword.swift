//
//  PageEditPassword.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/12/23.
//

import UIKit

class PageEditPassword:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    var input1:UITextField!
    var input2:UITextField!
    var input3:UITextField!
    
    var title1:UILabel!
    var title2:UILabel!
    var title3:UILabel!
    var btn:UIButton!
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        
        btn = sharedData.getBtnNext(title: "SUBMIT")
        btn.addEventListener(selector: #selector(self.goSubmit), target: self)
    }
    
    func initClass()
    {
        renderDetails()
    }
    
    @objc func renderDetails()
    {
        mainCon.removeSubViews()
        
        let topBar = sharedData.getTopBarBig(title: "Update Password")
        topBar.addBack(selector: #selector(self.goBack), target: self)
        mainCon.addSubview(topBar)
        
        let padding:CGFloat = 20
        
        title1 = UILabel()
        title1.text = "Current Password"
        title1.textColor = .black
        title1.x = padding
        title1.width = 200
        title1.height = 20
        title1.y = 110
        title1.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        mainCon.addSubview(title1)
        
        input1 = UITextField()
        input1.width = sharedData.screenWidth - (padding * 2)
        input1.backgroundColor = .white
        input1.x = padding
        input1.y = title1.posY() + 10
        input1.returnKeyType = .next
        input1.height = 50
        input1.borderStyle = .roundedRect
        input1.isSecureTextEntry = true
        input1.paddingLeft(10)
        input1.delegate = self
        input1.text = ""
        mainCon.addSubview(input1)
    
        input1.becomeFirstResponder()
        
        
        title2 = UILabel()
        title2.text = "New Password"
        title2.textColor = .black
        title2.x = padding
        title2.width = 200
        title2.height = 20
        title2.y = input1.posY() + 20
        title2.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        mainCon.addSubview(title2)
        
        input2 = UITextField()
        input2.width = sharedData.screenWidth - (padding * 2)
        input2.backgroundColor = .white
        input2.x = padding
        input2.y = title2.posY() + 10
        input2.returnKeyType = .next
        input2.height = 50
        input2.borderStyle = .roundedRect
        input2.paddingLeft(10)
        input2.isSecureTextEntry = true
        input2.delegate = self
        input2.text = ""
        mainCon.addSubview(input2)
        
        
        title3 = UILabel()
        title3.text = "Confirm New Password"
        title3.textColor = .black
        title3.x = padding
        title3.width = 200
        title3.height = 20
        title3.y = input2.posY() + 20
        title3.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        mainCon.addSubview(title3)
        
        input3 = UITextField()
        input3.width = sharedData.screenWidth - (padding * 2)
        input3.backgroundColor = .white
        input3.x = padding
        input3.y = title3.posY() + 10
        input3.returnKeyType = .done
        input3.height = 50
        input3.isSecureTextEntry = true
        input3.borderStyle = .roundedRect
        input3.paddingLeft(10)
        input3.delegate = self
        input3.text = ""
        mainCon.addSubview(input3)
        
        
        
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
       
        
        
        return true
        
       // return true
    }
    
    @objc func goSubmit()
    {
        input1.resignFirstResponder()
        input2.resignFirstResponder()
        input3.resignFirstResponder()
        
        if(input1.text! == "" || input2.text! == "" || input3.text! == "")
        {
            sharedData.showMessage(title: "Error", message: "Please input all fields")
            return
        }
        
        if(input2.text!.count < 8)
        {
            sharedData.showMessage(title: "Error", message: "New Passwords must be at least 8 characters")
            return
        }
        
        if(input2.text! != input3.text!)
        {
            sharedData.showMessage(title: "Error", message: "New Passwords must match")
            return
        }
        
        sharedData.postEvent(event: "SHOW_LOADING")
        
        
        sharedData.postIt(urlString: sharedData.base_domain + "/api-ios/update-password", params: ["confirm_password":input1.text!,"password":input2.text!], callback: {
            success, result_dict in
            
            self.sharedData.postEvent(event: "HIDE_LOADING")
            if((result_dict.object(forKey: "success") as! Bool) == true)
            {
                //let result = (result_dict.object(forKey: "result") as! NSDictionary)
                self.sharedData.setUserData(key: "user_pass", value: self.input2.text!)
                self.sharedData.postEvent(event: "INFO_RELOAD")
                self.goBack()
                //self.sharedData.showMessage(title: "Alert", message: "Success!")
            }else{
                self.sharedData.showMessage(title: "Error", message: (result_dict.object(forKey: "error_message") as! String))
            }
        })
        
    }
    
    @objc func hideKeyboard()
    {
        input1.resignFirstResponder()
        input2.resignFirstResponder()
        input3.resignFirstResponder()
    }
    
    @objc func goBack()
    {
        input1.resignFirstResponder()
        input2.resignFirstResponder()
        input3.resignFirstResponder()
        sharedData.postEvent(event: "EDIT_BACK")
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
