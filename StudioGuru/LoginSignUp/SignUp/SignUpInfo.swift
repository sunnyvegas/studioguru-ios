//
//  SignUpInfo.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/13/23.
//

import UIKit

class SignUpInfo:BasePage, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    
    var input1:UITextField!
    var input2:UITextField!
    
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
        label1.text = "Full Name"
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
        input1.height = 50
        input1.borderStyle = .roundedRect
        input1.paddingLeft(10)
        input1.delegate = self
        input1.text = ""
        mainCon.addSubview(input1)
        
        let label2 = UILabel()
        label2.text = "Birth Date"
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
        input2.returnKeyType = .done
        input2.height = 50
        input2.borderStyle = .roundedRect
        input2.paddingLeft(10)
        input2.delegate = self
        input2.text = ""
        input2.placeholder = "MM/DD/YYYY"
        input2.keyboardType = .numberPad
        mainCon.addSubview(input2)
        
        let toolbar = sharedData.getToolBar(target: self, selector: #selector(self.hideKeyboard), title: "Done", direction: "right")
        input2.inputAccessoryView = toolbar
        
        let btn = sharedData.getBtnNext(title: "NEXT")
        btn.addEventListener(selector: #selector(self.goNext), target: self)
        btn.y = input2.posY() + 20
        mainCon.addSubview(btn)
        
    }
    
    @objc func hideKeyboard()
    {
        input1.resignFirstResponder()
        input2.resignFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        
        
        if(textField ==  input2)
        {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = sharedData.formatPhone(with: "XX/XX/XXXX", phone: newString)
            
            if(textField.text!.count > 10)
            {
                textField.text = textField.text![0..<10]
            }
            
            return false
        }
       
        
        
        return true
        
       // return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        
        if(textField == input1)
        {
            input2.becomeFirstResponder()
        }
        
        return true
    }
    
    @objc func goNext()
    {
        if(input1.text! == "" || input2.text! == "")
        {
            sharedData.showMessage(title: "Error", message: "Please input all fields")
            return
        }
        
        if(input2.text!.is18() == false)
        {
            sharedData.showMessage(title: "Error", message: "You must be 18 to sign up.")
            return
        }
        hideKeyboard()
        sharedData.cSignUpPage = 2
        sharedData.postEvent(event: "SIGNUP_UPDATE_PAGES")
    }
    
    @objc func goPrev()
    {
        hideKeyboard()
        sharedData.cSignUpPage = 0
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
