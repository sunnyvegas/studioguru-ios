//
//  PMAddCreditCard.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/12/23.
//

import UIKit

class PMAddCreditCard:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var title1:UILabel!
    var title2:UILabel!
    
    
    
    var input1:UITextField!
    var input2:UITextField!
    
    var mainCon:UIView!
    
   override init (frame : CGRect)
   {
       super.init(frame : frame)
       sharedData = SharedData.sharedInstance
       backgroundColor = .white
       
       mainCon = UIView(frame: sharedData.fullRect)
       addSubview(mainCon)
   }
    
    func initClass()
    {
        renderDetails()
    }
    
    @objc func renderDetails()
    {
        mainCon.removeSubViews()
        
        let topBar = sharedData.getTopBarBig(title: "Add Credit Card")
        topBar.addExit(selector: #selector(self.goExit), target: self)
        mainCon.addSubview(topBar)
        
        let padding:CGFloat = 20
        
        title1 = UILabel()
        title1.text = "Nick Name"
        title1.textColor = .black
        title1.x = padding
        title1.width = 200
        title1.height = 20
        title1.y = topBar.posY() + 20
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
        input1.paddingLeft(10)
        input1.delegate = self
        input1.text = ""
        mainCon.addSubview(input1)
        
        
        
        title2 = UILabel()
        title2.text = "Card Number"
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
        input2.returnKeyType = .done
        input2.height = 50
        input2.keyboardType = .numberPad
        input2.borderStyle = .roundedRect
        input2.paddingLeft(10)
        input2.delegate = self
        input2.text = ""
        mainCon.addSubview(input2)
        
        let toolbar = sharedData.getToolBar(target: self, selector: #selector(self.hideKeyboard), title: "Done", direction: "right")
        input2.inputAccessoryView = toolbar
        
        let btn = sharedData.getBtnNext(title: "SUBMIT")
        btn.addEventListener(selector: #selector(self.goSubmit), target: self)
        btn.y = input2.posY() + 20
        mainCon.addSubview(btn)
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(textField == input2)
        {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = sharedData.formatPhone(with: "XXXX XXXX XXXX XXXX", phone: newString)
            
            if(textField.text!.count > 19)
            {
                textField.text = textField.text![0..<19]
            }
            
            return false
        }
       
        
        
        return true
        
       // return true
    }
    
    @objc func hideKeyboard()
    {
        input1.resignFirstResponder()
        input2.resignFirstResponder()
    }
    
    @objc func goSubmit()
    {
        hideKeyboard()
        
        if(input1.text! == "" || input2.text! == "")
        {
            sharedData.showMessage(title: "Error", message: "Please input all fields.")
            return
        }
        
        let title = input1.text!
        let card_number = input2.text!.components(separatedBy: " ").joined()
        print("card_number->",card_number)
        if(card_number.count < 16)
        {
            sharedData.showMessage(title: "Error", message: "Credit Card must be 16 characters")
            return
        }
        
        sharedData.postEvent(event: "SHOW_LOADING")
        
        sharedData.postIt(urlString: sharedData.base_domain + "/api-ios/add-payment-methods", params: ["card_number":card_number, "title":title, "type":"credit_card"], callback:
        {
            success, result_dict in
            
            self.sharedData.postEvent(event: "HIDE_LOADING")
            if((result_dict.object(forKey: "success") as! Bool) == true)
            {
                self.sharedData.showMessage(title: "Success!", message: "Credit Card Added!")
                self.sharedData.postEvent(event: "RELOAD_PAYMENT_METHODS")
                self.goExit()
            }else{
                self.sharedData.showMessage(title: "Error", message: (result_dict.object(forKey: "error_message") as! String))
            }
        })
        
        
    }
    
    @objc func goExit()
    {
        hideKeyboard()
        animateDown()
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
