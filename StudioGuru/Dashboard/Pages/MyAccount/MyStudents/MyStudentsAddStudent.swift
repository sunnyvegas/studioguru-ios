//
//  MyStudentsAddStudent.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/12/23.
//

import UIKit

class MyStudentsAddStudent:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    
    var title1:UILabel!
    var title2:UILabel!
    
    
    
    var input1:UITextField!
    var input2:UITextField!
    
    var btnPhoto:UIButton!
    
    var img_url = ""
    
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
        
        let topBar = sharedData.getTopBarBig(title: "Add Student")
        topBar.addExit(selector: #selector(self.goExit), target: self)
        mainCon.addSubview(topBar)
        
        let padding:CGFloat = 20
        
        title1 = UILabel()
        title1.text = "Student Name"
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
        title2.text = "Birth Date"
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
        input2.placeholder = "MM/DD/YYYY"
        mainCon.addSubview(input2)
        
        let toolbar = sharedData.getToolBar(target: self, selector: #selector(self.hideKeyboard), title: "Done", direction: "right")
        input2.inputAccessoryView = toolbar
        
        btnPhoto = UIButton(type: .roundedRect)
        btnPhoto.width = sharedData.screenWidth/3
        btnPhoto.height = sharedData.screenWidth/3
        btnPhoto.corner(radius: sharedData.screenWidth/6)
        btnPhoto.x = sharedData.screenWidth/2 - btnPhoto.width/2
        btnPhoto.setBackgroundImage(UIImage(named:"camera_upload"), for: .normal)
        btnPhoto.y =  input2.posY() + 20
        btnPhoto.imageView?.contentMode = .scaleAspectFill
        btnPhoto.backgroundColor = .white
        btnPhoto.layer.borderWidth = 1
        btnPhoto.layer.borderColor = UIColor.lightGray.cgColor
        btnPhoto.addEventListener(selector: #selector(self.goUpdatePhoto), target: self)
        mainCon.addSubview(btnPhoto)
        
        let btn = sharedData.getBtnNext(title: "SUBMIT")
        btn.addEventListener(selector: #selector(self.goSubmit), target: self)
        btn.y = btnPhoto.posY() + 20
        mainCon.addSubview(btn)
        
        sharedData.addEventListener(title: "UPDATE_ADD_STUDENT_PHOTO", target: self, selector: #selector(self.updateUserPhoto))
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
            textField.text = sharedData.formatPhone(with: "XX/XX/XXXX", phone: newString)
            
            if(textField.text!.count > 19)
            {
                textField.text = textField.text![0..<19]
            }
            
            return false
        }
       
        
        
        return true
        
       // return true
    }
    
    @objc func updateUserPhoto()
    {
        btnPhoto.setBackgroundImage(sharedData.c_image, for: .normal)
        
        let image_data = (sharedData.c_image.resizeImage(newWidth: 600)).jpegData(compressionQuality: 0.9)!
        
        let url = sharedData.base_domain + "/api-files/upload"
        //sharedData.postEvent(event: "SHOW_LOADING")
        let filesA = NSMutableArray()
        let dict = NSMutableDictionary()
        dict.setObject(image_data, forKey: "data" as NSCopying)
        dict.setObject("file", forKey: "file_name" as NSCopying)
        dict.setObject("photo.jpg", forKey: "fileName" as NSCopying)
        dict.setObject("image/jpg", forKey: "mimeType" as NSCopying)
        filesA.add(dict)
        
        
        //(sharedData.preview_dict.object(forKey: "questions") as! NSArray)
        sharedData.postEvent(event: "SHOW_LOADING")
        sharedData.postItWithFile(urlString: url, params: [:], filesA: filesA, callback:
                                    {
            success, result_dict in
            
            print("result_dict")
            print(result_dict)
            
            self.img_url = (result_dict.object(forKey: "result") as! String)
            
            print("img_url--------------------->",self.img_url)
            self.sharedData.postEvent(event: "HIDE_LOADING")
            
            //let params = [self.sharedData.edit_key:img_url ]
            
            
            
//            self.sharedData.postIt(urlString:  self.sharedData.base_domain + "/api-ios/update-details", params: params as [String : Any], callback:
//            { success, result_dict in
//
//
//                self.sharedData.imagesDict.removeAllObjects()
//                self.sharedData.postEvent(event: "HIDE_LOADING")
//                self.sharedData.postEvent(event: "INFO_RELOAD")
//                self.sharedData.postEvent(event: "EDIT_BACK")
//
//            })
            
            
            
        })
    }
    
    @objc func goUpdatePhoto()
    {
        let optionMenu = UIAlertController(title: "Select Photo Source", message: "", preferredStyle: .actionSheet)
        
        let libAction = UIAlertAction(title: "Upload From Library", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.sharedData.c_image_state  = "add_student_photo"
            self.sharedData.postEvent(event: "ADD_PHOTO_LIBRARY")
            
            
           
        })
        optionMenu.addAction(libAction)
        
        
        
        let camAction = UIAlertAction(title: "Upload From Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.sharedData.c_image_state  = "add_student_photo"
            self.sharedData.postEvent(event: "ADD_PHOTO_CAMERA")
            
            
        })
        
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:
        {
            (alert: UIAlertAction!) -> Void in
        
        })
        
        
        optionMenu.addAction(camAction)
        optionMenu.addAction(cancelAction)
        
        self.window?.rootViewController?.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func hideKeyboard()
    {
        input1.resignFirstResponder()
        input2.resignFirstResponder()
    }
    
    @objc func goSubmit()
    {
        hideKeyboard()
        
        let student_name = input1.text!
        let birth_date = input2.text!
        
        if(student_name == "" || birth_date == "")
        {
            sharedData.showMessage(title: "Error", message: "Please input all fields")
            return
        }
        
        if(img_url == "")
        {
            sharedData.showMessage(title: "Error", message: "Please upload a photo")
            return
        }
       
        sharedData.postEvent(event: "SHOW_LOADING")
        
        sharedData.postIt(urlString: sharedData.base_domain + "/api-ios/add-student", params: ["student_name":student_name, "birth_date":birth_date, "photo":img_url], callback:
        {
            success, result_dict in
            
            self.sharedData.postEvent(event: "HIDE_LOADING")
            if((result_dict.object(forKey: "success") as! Bool) == true)
            {
                self.sharedData.showMessage(title: "Success!", message: "Student Added!")
                self.sharedData.postEvent(event: "RELOAD_MYSTUDENTS")
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
