//
//  PageEditPhoto.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/12/23.
//

import UIKit

class PageEditPhoto:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    
    var btnPhoto:UIButton!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        
        let topBar = sharedData.getTopBarBig(title: "Photo")
        topBar.addBack(selector: #selector(self.goExit), target: self)
        addSubview(topBar)
        
        btnPhoto = UIButton(type: .roundedRect)
        btnPhoto.width = sharedData.screenWidth/3
        btnPhoto.height = sharedData.screenWidth/3
        btnPhoto.corner(radius: sharedData.screenWidth/6)
        btnPhoto.x = sharedData.screenWidth/2 - btnPhoto.width/2
        btnPhoto.setBackgroundImage(UIImage(named:"blank_person"), for: .normal)
        btnPhoto.y =  110
        btnPhoto.imageView?.contentMode = .scaleAspectFill
        btnPhoto.backgroundColor = .white
        btnPhoto.layer.borderWidth = 1
        btnPhoto.layer.borderColor = UIColor.lightGray.cgColor
        btnPhoto.addEventListener(selector: #selector(self.goUpdatePhoto), target: self)
        mainCon.addSubview(btnPhoto)
      
        
        let btnUpdatePhoto = UIButton(type: .custom)
        btnUpdatePhoto.y = 300
        btnUpdatePhoto.x = 20
        btnUpdatePhoto.width = sharedData.screenWidth - 40
        btnUpdatePhoto.height = 40
        btnUpdatePhoto.corner(radius: 5)
        btnUpdatePhoto.setTitle("UPDATE PHOTO", for: .normal)
        btnUpdatePhoto.setTitleColor(UIColor.white, for: .normal)
        btnUpdatePhoto.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        btnUpdatePhoto.backgroundColor = sharedData.blue
        btnUpdatePhoto.addEventListener(selector: #selector(self.goUpdatePhoto), target: self)
        mainCon.addSubview(btnUpdatePhoto)
        
        sharedData.addEventListener(title: "UPDATE_EDIT_USER_PHOTO", target: self, selector: #selector(self.updateUserPhoto))
    }
    
    func initClass()
    {
        renderDetails()
    }
    
    @objc func renderDetails()
    {
        btnPhoto.downloadedFrom(link: sharedData.edit_value)
    }
    
    @objc func goUpdatePhoto()
    {
       
        
        let optionMenu = UIAlertController(title: "Select Photo Source", message: "", preferredStyle: .actionSheet)
        
        let libAction = UIAlertAction(title: "Upload From Library", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.sharedData.c_image_state  = "update_user_profile"
            self.sharedData.postEvent(event: "ADD_PHOTO_LIBRARY")
            
            
           
        })
        optionMenu.addAction(libAction)
        
        
        
        let camAction = UIAlertAction(title: "Upload From Camera", style: .default, handler:
        {
            (alert: UIAlertAction!) -> Void in
            self.sharedData.c_image_state  = "update_user_profile"
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
            
            let img_url = (result_dict.object(forKey: "result") as! String)
            
            print("img_url--------------------->",img_url)
            
            
            let params = [self.sharedData.edit_key:img_url ]
            
            
            
            self.sharedData.postIt(urlString:  self.sharedData.base_domain + self.sharedData.edit_api, params: params as [String : Any], callback:
            { success, result_dict in
                
                
                self.sharedData.imagesDict.removeAllObjects()
                self.sharedData.postEvent(event: "HIDE_LOADING")
                self.sharedData.postEvent(event: self.sharedData.edit_event)
                self.sharedData.postEvent(event: "EDIT_BACK")
               
            })
            
            
            
        })
    }
  
    
   
  
    @objc func goExit()
    {
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
