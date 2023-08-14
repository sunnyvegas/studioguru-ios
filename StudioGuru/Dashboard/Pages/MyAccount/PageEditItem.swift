//
//  MyAccountEditItem.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/11/23.
//

import UIKit

class PageEditItem:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    var input:UITextField!
    var title:UILabel!
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
        
        let topBar = sharedData.getTopBarBig(title: sharedData.edit_title)
        topBar.addBack(selector: #selector(self.goBack), target: self)
        mainCon.addSubview(topBar)
        
        let padding:CGFloat = 20
        
        title = UILabel()
        title.text = sharedData.edit_title
        title.textColor = .black
        title.x = padding
        title.width = 200
        title.height = 20
        title.y = 110
        title.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        mainCon.addSubview(title)
        
        input = UITextField()
        input.width = sharedData.screenWidth - (padding * 2)
        input.backgroundColor = .white
        input.x = padding
        input.y = title.posY() + 10
        input.returnKeyType = .done
        input.height = 50
        input.borderStyle = .roundedRect
        input.paddingLeft(10)
        input.delegate = self
        input.text = sharedData.edit_value
        //inputEmail.corner(radius: 10)
        mainCon.addSubview(input)
        
        if(sharedData.edit_key == "phone")
        {
            input.keyboardType = .numberPad
            let toolbar = sharedData.getToolBar(target: self, selector: #selector(self.hideKeyboard), title: "Done", direction: "right")
            input.inputAccessoryView = toolbar
            
            input.text = sharedData.formatPhone(with: "XXX XXX XXXX", phone: sharedData.edit_value)
        }
        
        if(sharedData.edit_key == "birth_date")
        {
            input.keyboardType = .numberPad
            let toolbar = sharedData.getToolBar(target: self, selector: #selector(self.hideKeyboard), title: "Done", direction: "right")
            input.inputAccessoryView = toolbar
            
            input.text = sharedData.formatPhone(with: "XX/XX/XXXX", phone: sharedData.edit_value.mongoDate.formatDate())
            
        }
        
        input.becomeFirstResponder()
        
        btn.y = input.posY() + 20
        mainCon.addSubview(btn)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if(sharedData.edit_key == "phone")
        {
            guard let text = textField.text else { return false }
            let newString = (text as NSString).replacingCharacters(in: range, with: string)
            textField.text = sharedData.formatPhone(with: "XXX XXX XXXX", phone: newString)
            
            if(textField.text!.count > 12)
            {
                textField.text = textField.text![0..<12]
            }
            
            return false
        }
        
        if(sharedData.edit_key == "birth_date")
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
    
    @objc func goSubmit()
    {
        input.resignFirstResponder()
        sharedData.postEvent(event: "SHOW_LOADING")
        
        sharedData.postIt(urlString: sharedData.base_domain + sharedData.edit_api, params: [sharedData.edit_key:input.text!], callback: {
            success, result_dict in
            
            self.sharedData.postEvent(event: "HIDE_LOADING")
            if((result_dict.object(forKey: "success") as! Bool) == true)
            {
                //let result = (result_dict.object(forKey: "result") as! NSDictionary)
                
                self.sharedData.postEvent(event: self.sharedData.edit_event)
                self.goBack()
                //self.sharedData.showMessage(title: "Alert", message: "Success!")
            }else{
                self.sharedData.showMessage(title: "Error", message: (result_dict.object(forKey: "error_message") as! String))
            }
        })
        
        
    }
    
    @objc func hideKeyboard()
    {
        input.resignFirstResponder()
    }
    
    @objc func goBack()
    {
        input.resignFirstResponder()
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
