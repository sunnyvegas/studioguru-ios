//
//  SignUpPhoto.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/13/23.
//

import UIKit

class SignUpPhoto:BasePage, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    
    var btnPhoto:UIButton!
    
    var img_url:String!
    
   override init (frame : CGRect)
   {
       super.init(frame : frame)
       sharedData = SharedData.sharedInstance
       backgroundColor = .white
       
       img_url = ""
       
       mainCon = UIView(frame: sharedData.fullRect)
       addSubview(mainCon)
       
       let topBar = sharedData.getTopBarBig(title: "Photo")
       topBar.addBack(selector: #selector(self.goPrev), target: self)
       addSubview(topBar)
       
       btnPhoto = UIButton(type: .roundedRect)
       btnPhoto.width = sharedData.screenWidth/2
       btnPhoto.height = sharedData.screenWidth/2
       btnPhoto.corner(radius: sharedData.screenWidth/4)
       btnPhoto.x = sharedData.screenWidth/2 - btnPhoto.width/2
       btnPhoto.setBackgroundImage(UIImage(named:"camera_upload"), for: .normal)
       btnPhoto.y =  110
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
       
       sharedData.addEventListener(title: "UPDATE_PHOTO_SIGNUP", target: self, selector: #selector(self.updateUserPhoto))
   }
    
    override func initClass()
    {
    
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
            
//            let params = [self.sharedData.edit_key:img_url ]
//
//
//
//            self.sharedData.postIt(urlString:  self.sharedData.base_domain + self.sharedData.edit_api, params: params as [String : Any], callback:
//            { success, result_dict in
//
//
//                self.sharedData.imagesDict.removeAllObjects()
//                self.sharedData.postEvent(event: "HIDE_LOADING")
//                self.sharedData.postEvent(event: self.sharedData.edit_event)
//                self.sharedData.postEvent(event: "EDIT_BACK")
//
//            })
            
            
            
        })
    }
    
    @objc func goSubmit()
    {
        if(img_url == "")
        {
            sharedData.showMessage(title: "Error", message: "Please upload a photo.")
            return
        }
        
        let params = ["photo":img_url, "email":sharedData.s_email, "member_name":sharedData.s_name, "password":sharedData.s_password,"birth_date":sharedData.s_birth_date, "phone":"","phone_carrier":""]
        
        sharedData.postEvent(event: "SHOW_LOADING")
        
        self.sharedData.postIt(urlString:  sharedData.base_domain + "/mobile-ios/cust-signup", params: params as [String : Any], callback:
        { success, result_dict in

            print("RESULT")
            print(result_dict)
            self.sharedData.postEvent(event: "HIDE_LOADING")
            if((result_dict.object(forKey: "success") as! Bool) == true)
            {
                
                self.sharedData.showMessage(title: "Success!", message: "You can now login!")
                self.sharedData.postEvent(event: "SIGNUP_EXIT")
            }else{
                self.sharedData.showMessage(title: "Error", message: (result_dict.object(forKey: "error_message") as! String))
            }
            
            
        })
    }
    
    @objc func goUpdatePhoto()
    {
        let optionMenu = UIAlertController(title: "Select Photo Source", message: "", preferredStyle: .actionSheet)
        
        let libAction = UIAlertAction(title: "Upload From Library", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.sharedData.c_image_state  = "update_signup_photo"
            self.sharedData.postEvent(event: "ADD_PHOTO_LIBRARY")
            
            
           
        })
        optionMenu.addAction(libAction)
        
        
        
        let camAction = UIAlertAction(title: "Upload From Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.sharedData.c_image_state  = "update_signup_photo"
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
    
    @objc func goPrev()
    {
        
        sharedData.cSignUpPage = 2
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
