//
//  ViewController.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//

import UIKit
import AVFoundation
import AVKit
import Foundation
import MobileCoreServices

class ViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    var sharedData:SharedData!
    var dashPage:MainDashboard!
    var loadingCon:UIView!
    var noInternet:NoInternet!
    
    let reachability: Reachable? = Reachable.networkReachabilityForInternetConnection()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        sharedData = SharedData.sharedInstance
        
        let loginPage = Login(frame: sharedData.fullRect)
        view.addSubview(loginPage)
        dashPage = MainDashboard(frame: sharedData.fullRect)
        
        
        loadingCon = UIView(frame: sharedData.fullRect)
        loadingCon.backgroundColor = .black
        loadingCon.alpha = 0.5
        loadingCon.isHidden = true
        view.addSubview(loadingCon)
        
        let actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        actInd.hidesWhenStopped = true
        actInd.center = loadingCon.center
        if #available(iOS 13.0, *) {
            actInd.style = .large
        } else {
            // Fallback on earlier versions
        }
        actInd.startAnimating()
        loadingCon.addSubview(actInd)
        
        
        
        noInternet = NoInternet(frame: sharedData.fullRectBottom)
        view.addSubview(noInternet)
        
//        let dashPage = Dashboard(frame: sharedData.fullRect)
//        view.addSubview(dashPage)
        
        sharedData.addEventListener(title: "SHOW_DASHBOARD", target: self, selector: #selector(self.goDash))
        sharedData.addEventListener(title: "LOG_OUT", target: self, selector: #selector(self.goLogOut))
        
        sharedData.addEventListener(title: "SHOW_LOADING", target: self, selector: #selector(self.showLoading))
        
        sharedData.addEventListener(title: "HIDE_LOADING", target: self, selector: #selector(self.hideLoading))
        
        
        sharedData.addEventListener(title: "ADD_PHOTO_LIBRARY", target: self, selector: #selector(self.goPickPhotoLibrary))
        sharedData.addEventListener(title: "ADD_PHOTO_CAMERA", target: self, selector: #selector(self.goPickPhotoCamera))
        sharedData.addEventListener(title: "ADD_VIDEO_CAMERA", target: self, selector: #selector(self.goPickVideoCamera))
        sharedData.addEventListener(title: "ADD_VIDEO_LIBRARY", target: self, selector: #selector(self.goPickVideoLibrary))
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillChange), name: UIResponder.keyboardDidChangeFrameNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityDidChange(_:)), name: NSNotification.Name(rawValue: ReachabilityDidChangeNotificationName), object: nil)
        
        
        
        
         
            _ = reachability?.startNotifier()
        
        
        
        sharedData.setTimeout(delay: 0.1, block: {
            
            self.checkReachability()
        })
        
        
    }
    
    @objc func reachabilityDidChange(_ notification: Notification)
    {
        checkReachability()
    }
    
    func checkReachability()
    {
        guard let r = reachability else { return }
        if r.isReachable
        {
            sharedData.is_online = true
            noInternet.animateDown()
        }else{
            sharedData.is_online = false
            noInternet.y = sharedData.screenHeight
            view.addSubview(noInternet)
            noInternet.animateUp()
        }
    }
    
    @objc func goDash()
    {
        dashPage.y = sharedData.screenHeight
        view.addSubview(dashPage)
        dashPage.initClass()
        dashPage.animateUp()
    }
    
    @objc func keyboardWillChange(notification: NSNotification)
    {
        //print("keyboardWillChange============")
        
        //let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        //let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        //let curFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let targetFrame = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        //let deltaY = targetFrame.origin.y - curFrame.origin.y
        sharedData.keyboardHeight = targetFrame.size.height
    }
    
    @objc func keyboardWillShow(_ notification: Notification)
    {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            // Calculate the keyboard height
            let keyboardHeight = keyboardSize.height
            print("Keyboard will show. Height: \(keyboardHeight)")
            sharedData.keyboardHeight = keyboardHeight
            
            // You can use the keyboardHeight as needed, for example, to adjust the layout.
        }
    }

    @objc func keyboardWillHide(_ notification: Notification)
    {
        print("Keyboard will hide")
        
        // Reset any layout adjustments made when the keyboard was shown.
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }





    
    @objc func showLoading()
    {
        view.addSubview(loadingCon)
        loadingCon.isHidden = false
    }
    
    @objc func hideLoading()
    {
        loadingCon.isHidden = true
    }
    
    @objc func goLogOut()
    {
        self.sharedData.setUserData(key: "user_email", value: "")
        self.sharedData.setUserData(key: "user_pass", value: "")
        self.sharedData.setUserData(key: "studio_id", value: "")
        self.sharedData.studio_id = ""
        self.sharedData.studio_name = ""
        self.sharedData.member_id = ""
        self.sharedData.member_token = ""
        self.sharedData.member_name = ""
        dashPage.animateDown()
    }
    
    @objc func goPickVideoLibrary()
    {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        
        //imagePickerController.cameraDevice = UIImagePickerController.CameraDevice.front
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.isEditing = true
        imagePickerController.allowsEditing = true
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        present(imagePickerController, animated: true, completion:
        {
                //self.view.window?.rootViewController?.view.addSubview(self.uploadPhoto)
                //self.uploadPhoto.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        })
    }
    
    @objc func goPickVideoCamera()
    {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .camera
        
        imagePickerController.cameraDevice = .front
        //imagePickerController.cameraDevice = UIImagePickerController.CameraDevice.front
        imagePickerController.mediaTypes = [kUTTypeMovie as String]
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.isEditing = true
        imagePickerController.allowsEditing = true
        imagePickerController.videoMaximumDuration = 60
        present(imagePickerController, animated: true, completion:
            {
                //self.view.window?.rootViewController?.view.addSubview(self.uploadPhoto)
                //self.uploadPhoto.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        })
    }
    
    @objc func goPickPhotoCamera()
    {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .camera
        
        imagePickerController.cameraDevice = .front
        //imagePickerController.cameraDevice = UIImagePickerController.CameraDevice.front
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.isEditing = true
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion:
            {
                //self.view.window?.rootViewController?.view.addSubview(self.uploadPhoto)
                //self.uploadPhoto.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        })
    }
    
    @objc func goPickPhotoLibrary()
    {
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        
        //imagePickerController.cameraDevice = UIImagePickerController.CameraDevice.front
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        imagePickerController.isEditing = true
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion:
            {
                //self.view.window?.rootViewController?.view.addSubview(self.uploadPhoto)
                //self.uploadPhoto.frame = CGRect(x: 0, y: 0, width: self.screenWidth, height: self.screenHeight)
        })
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        //dismiss(animated: true, completion: nil)
        //return
        print("info",info)
        
        
        // Set photoImageView to display the selected image.
        //photoImageView.image = selectedImage
        
        
        if(sharedData.c_image_state == "update_user_profile_video")
        {
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as AnyObject

                if mediaType as! String == kUTTypeMovie as String {
                    let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                        print("VIDEO URL: \(videoURL!)")
                    sharedData.c_vid_url = videoURL
                    sharedData.postEvent(event: "UPDATE_USER_VIDEO")
                }
            
        }
        
        if(sharedData.c_image_state == "update_signup_video")
        {
            //UPDATE_VIDEO_SIGNUP
            
            let mediaType = info[UIImagePickerController.InfoKey.mediaType] as AnyObject

                if mediaType as! String == kUTTypeMovie as String {
                    let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL
                        print("VIDEO URL: \(videoURL!)")
                    sharedData.c_vid_url = videoURL
                    sharedData.postEvent(event: "UPDATE_VIDEO_SIGNUP")
                }
        }
   
        
        if(sharedData.c_image_state == "update_user_profile")
        {
            sharedData.c_image = info[.editedImage] as? UIImage
            //sharedData.c_image = sharedData.c_image
            sharedData.postEvent(event: "UPDATE_EDIT_USER_PHOTO")
        }
        
        if(sharedData.c_image_state == "add_student_photo")
        {
            sharedData.c_image = info[.editedImage] as? UIImage
            //sharedData.c_image = sharedData.c_image
            sharedData.postEvent(event: "UPDATE_ADD_STUDENT_PHOTO")
        }
        
        
        
        if(sharedData.c_image_state == "update_signup_photo")
        {
            sharedData.c_image = info[.editedImage] as? UIImage
            sharedData.postEvent(event: "UPDATE_PHOTO_SIGNUP")
        }
        
//        if(sharedData.c_image_state == "events_invited")
//        {
//            sharedData.c_image = sharedData.c_image
//            sharedData.postEvent(event: "UPDATE_EVENTS_PHOTO_INVITE")
//        }
//
//        if(sharedData.c_image_state == "my_profile")
//        {
//            sharedData.c_image = sharedData.c_image
//            sharedData.postEvent(event: "UPDATE_PROFILE_PHOTO")
//       }
        
        dismiss(animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}




class BasePage: UIView
{
    override init (frame : CGRect)
    {
        super.init(frame : frame)
    }
    
    func initClass()
    {
        
    }
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}




extension UIFont
{
    var bold: UIFont {
        return with(traits: .traitBold)
    } // bold
    
    var italic: UIFont {
        return with(traits: .traitItalic)
    } // italic
    
    var boldItalic: UIFont {
        return with(traits: [.traitBold, .traitItalic])
    } // boldItalic
    
    
    func with(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = self.fontDescriptor.withSymbolicTraits(traits) else {
            return self
        } // guard
        
        return UIFont(descriptor: descriptor, size: 0)
    } // with(traits:)
}


extension UIView
{
    func rotate(angle: CGFloat)
    {
      let radians = angle / 180.0 * CGFloat.pi
    let rotation = self.transform.rotated(by: radians);
      self.transform = rotation
    }
    
    func padding(num:CGFloat)
    {
        self.layoutMargins = UIEdgeInsets(top: num, left: num, bottom: num, right: num)
    }
    
    func animateDown()
    {
        self.endEditing(true)
        UIView.animate(withDuration: 0.25)
        {
            self.y = UIScreen.main.bounds.height
            
        }
    }
    
    func animateUp()
    {
        UIView.animate(withDuration: 0.25)
        {
            self.y = 0
        }
    }
    
    func animateLeft()
    {
        UIView.animate(withDuration: 0.25)
        {
            self.x = self.width * -1
        }
    }
    
    func animateRight()
    {
        UIView.animate(withDuration: 0.25)
        {
            self.x = self.width
        }
    }
    
    func animateBackX()
    {
        UIView.animate(withDuration: 0.25)
        {
            self.x = 0
        }
    }
    
    func animateBackY()
    {
        UIView.animate(withDuration: 0.25)
        {
            self.y = 0
        }
    }
    
    func animateBack()
    {
        UIView.animate(withDuration: 0.25)
        {
            self.x = 0
            self.y = 0
        }
    }
    
    
    func addDropShadow()
    {
        self.layer.cornerRadius = 10
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowRadius = 5
    }
    
    func bounce(time: Double)
    {
        
        self.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        UIView.animate(withDuration: time,
                       delay: 0,
                       usingSpringWithDamping: CGFloat(0.50),
                       initialSpringVelocity: CGFloat(6.0),
                       options: UIView.AnimationOptions.allowUserInteraction,
                       animations: {
                        self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        },
                       completion: { Void in()  }
        )
    }
    
    func corner(radius:CGFloat)
    {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    func cornerSides(topLeft:Bool, topRight:Bool, bottomLeft:Bool, bottomRight:Bool, cornerRadius:CGFloat)
    {
        
        var cornersA:UIRectCorner = []
        
        if(topLeft == true)
        {
            cornersA.insert(.topLeft)
        }
        
        if(topRight == true)
        {
            cornersA.insert(.topRight)
        }
        
        
        if(bottomLeft == true)
        {
            cornersA.insert(.bottomLeft)
        }
        
        if(bottomRight == true)
        {
            cornersA.insert(.bottomRight)
        }
        
        let corners = UIRectCorner(arrayLiteral: cornersA)
        
//        let corners = UIRectCorner(arrayLiteral: [
//            UIRectCorner.topLeft,
//            UIRectCorner.topRight,
//            UIRectCorner.bottomLeft,
//            UIRectCorner.bottomRight
//        ])
        
        

        // Determine the size of the rounded corners
        let cornerRadii = CGSize.self(
            width: cornerRadius,
            height: cornerRadius
        )

        // A mask path is a path used to determine what
        // parts of a view are drawn. UIBezier path can
        // be used to create a path where only specific
        // corners are rounded
        let maskPath = UIBezierPath(
            roundedRect: self.bounds,
            byRoundingCorners: corners,
            cornerRadii: cornerRadii
        )

        // Apply the mask layer to the view
        let maskLayer = CAShapeLayer()
        maskLayer.path = maskPath.cgPath
        maskLayer.frame = self.bounds

        self.layer.mask = maskLayer
    }
    
    
    func border(lineWidth:CGFloat)
    {
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = lineWidth
    }
    
    func posY() -> CGFloat
    {
        return self.frame.size.height + self.frame.origin.y
    }
    
    func posX() -> CGFloat
    {
        return self.frame.size.width + self.frame.origin.x
    }
    
    
    func hideModal()
    {
        UIView.animate(withDuration: 0.25)
        {
            //self.frame = CGRectMake(0, UIScreen.main.bounds.height, UIScreen.main.bounds.width, UIScreen.main.bounds.height)
        }
    }
    
    
    func showModal()
    {
        UIView.animate(withDuration: 0.25)
        {
            //self.frame = CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height)
        }
    }
    
    func removeSubViews()
    {
        for view in self.subviews
        {
            view.removeFromSuperview()
        }
    }
    
    
    //var width:      CGFloat { return self.frame.size.width }
    //var height:     CGFloat { return self.frame.size.height }
    var size:       CGSize  { return self.frame.size}
    
    var origin:     CGPoint { return self.frame.origin }
    //var x:          CGFloat { return self.frame.origin.x }
    //var y:          CGFloat { return self.frame.origin.y }
    var centerX:    CGFloat { return self.center.x }
    var centerY:    CGFloat { return self.center.y }
    
    var left:       CGFloat { return self.frame.origin.x }
    var right:      CGFloat { return self.frame.origin.x + self.frame.size.width }
    var top:        CGFloat { return self.frame.origin.y }
    var bottom:     CGFloat { return self.frame.origin.y + self.frame.size.height }
    
    
    
    var x: CGFloat!
    {
        get {
            return self.frame.origin.x
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: newValue,y :self.frame.origin.y)
        }
    }
    
    var y: CGFloat!
    {
        get {
            return self.frame.origin.y
        }
        set(newValue) {
            self.frame.origin = CGPoint(x: self.frame.origin.x,y :newValue)
        }
    }
    
    
    
    var width: CGFloat!
    {
        get {
            return self.frame.size.width
        }
        set(newValue) {
            self.frame.size = CGSize(width: newValue, height: self.frame.size.height)
        }
    }
    
    
    var height: CGFloat!
    {
        get {
            return self.frame.size.height
        }
        set(newValue) {
            self.frame.size = CGSize(width: self.frame.size.width, height: newValue)
        }
    }
    
    
    
}


extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex:Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
    
    func theme() -> UIColor
    {
        return UIColor(hex: 0x007ee0)
    }
}


extension UIImage {
    func crop( rect: CGRect) -> UIImage {
        var rect = rect
        rect.origin.x*=self.scale
        rect.origin.y*=self.scale
        rect.size.width*=self.scale
        rect.size.height*=self.scale
        
        let imageRef = self.cgImage!.cropping(to: rect)
        let image = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return image
    }
    
    func scaleImage(toSize newSize: CGSize) -> UIImage? {
        let newRect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height).integral
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            context.interpolationQuality = .high
            let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: newSize.height)
            context.concatenate(flipVertical)
            context.draw(self.cgImage!, in: newRect)
            let newImage = UIImage(cgImage: context.makeImage()!)
            UIGraphicsEndImageContext()
            return newImage
        }
        return nil
    }
    
    func resizeImage( newWidth: CGFloat) -> UIImage {
        
        let image = self
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return (newImage?.rotate(deg: 0))!
    }
    
    func rotate( deg degrees: CGFloat) -> UIImage {
        
        print("rotation")
        let oldImage = self
        //Calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox: UIView = UIView(frame: CGRect(x:0, y:0, width:oldImage.size.width, height:oldImage.size.height))
        let t: CGAffineTransform = CGAffineTransform(rotationAngle: degrees * CGFloat(M_PI / 180))
        rotatedViewBox.transform = t
        let rotatedSize: CGSize = rotatedViewBox.frame.size
        //Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap: CGContext = UIGraphicsGetCurrentContext()!
        //Move the origin to the middle of the image so we will rotate and scale around the center.
        bitmap.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)
        //Rotate the image context
        bitmap.rotate(by: (degrees * CGFloat(M_PI / 180)))
        //Now, draw the rotated/scaled image into the context
        bitmap.scaleBy(x: 1.0, y: -1.0)
        bitmap.draw(oldImage.cgImage!, in: CGRect(x:-oldImage.size.width / 2, y:-oldImage.size.height / 2, width:oldImage.size.width, height:oldImage.size.height))
        //CGContextDrawImage(bitmap, CGRect(x:-oldImage.size.width / 2, y:-oldImage.size.height / 2, width:oldImage.size.width, oldImage.size.height), oldImage.cgImage)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
    func grayScale() -> UIImage {
        
        let filter = CIFilter(name: "CIPhotoEffectMono")
        
        // convert UIImage to CIImage and set as input
        
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }
    
    convenience init(view: UIView)
    {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
    
}



extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        
        let sharedData = SharedData.sharedInstance
        
        if(sharedData.imagesDict.object(forKey: url) != nil)
        {
            let imgData = sharedData.imagesDict.object(forKey: url) as! UIImage
            //self.setBackgroundImage(imgData, forState: UIControlState.Normal)
            self.image = imgData
            self.contentMode = mode
            
    
            //self.contentMode = UIViewContentMode.scaleAspectFill
            //self.image = UIImage(data: imgData)
        }else{
            
            /*
             if let url = NSURL(string: urlString) {
                 let request = NSURLRequest(url: url as URL)
                 NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                     (response: URLResponse?, data: Data?, error: Error?) -> Void in
                     //self.image = UIImage(data: data)
                     mainImage.image = UIImage(data: data!)
                 }
             }
             
             */
            
            
                let request = NSURLRequest(url: url)
                NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                    (response: URLResponse?, data: Data?, error: Error?) -> Void in
                    //self.image = UIImage(data: data)
                    
                    let image = UIImage(data: data!)
                    //self.image = UIImage(data: data!)
                    
                    DispatchQueue.main.async() { () -> Void in
                        
                        
                        let sharedData = SharedData.sharedInstance
                        sharedData.imagesDict.setObject(UIImage(data: data!)!, forKey: url as NSCopying)
                        self.image = image
                        
                    }
                }
            
            
            /*
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { () -> Void in
                    
                    
                    let sharedData = SharedData.sharedInstance
                    sharedData.imagesDict.setObject(UIImage(data: data)!, forKey: url as NSCopying)
                    self.image = image
                    
                }
                }.resume()
            */
        }
        
        
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func resizeImage( newWidth: CGFloat) -> UIImage?
    {
        
        let scale = newWidth / self.size.width
        let newHeight = self.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        self.draw(CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}




extension UIButton
{
    func paddingB(num: CGFloat)
    {
        self.contentEdgeInsets = UIEdgeInsets(top: num, left: num, bottom: num, right: num)
    }
    
    func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        contentMode = mode
        
        let sharedData = SharedData.sharedInstance
        
        if(sharedData.imagesDict.object(forKey: url) != nil)
        {
            let imgData = sharedData.imagesDict.object(forKey: url) as! UIImage
            //self.setBackgroundImage(imgData, forState: UIControlState.Normal)
            self.setBackgroundImage(imgData, for: UIControl.State.normal)
            self.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
            //self.image = UIImage(data: imgData)
            self.contentMode = mode
        }else{
            let request = NSURLRequest(url: url)
            NSURLConnection.sendAsynchronousRequest(request as URLRequest, queue: OperationQueue.main) {
                (response: URLResponse?, data: Data?, error: Error?) -> Void in
                //self.image = UIImage(data: data)
                
                let image = UIImage(data: data!)
                //self.image = UIImage(data: data!)
                
                DispatchQueue.main.async() { () -> Void in
                    self.setBackgroundImage(image, for: UIControl.State.normal)
                    //self.setImage(image, for: UIControlState.normal)
                    //self.contentMode = UIViewContentMode.scaleAspectFill
                    self.imageView?.contentMode = UIView.ContentMode.scaleAspectFill
                    
                    let sharedData = SharedData.sharedInstance
                    sharedData.imagesDict.setObject(UIImage(data: data!)!, forKey: url as NSCopying)
                }
            }
            /*
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                    else { return }
                DispatchQueue.main.async() { () -> Void in
                    self.setBackgroundImage(image, for: UIControlState.normal)
                    //self.setImage(image, for: UIControlState.normal)
                    //self.contentMode = UIViewContentMode.scaleAspectFill
                    self.imageView?.contentMode = UIViewContentMode.scaleAspectFill
                    
                    let sharedData = SharedData.sharedInstance
                    sharedData.imagesDict.setObject(UIImage(data: data)!, forKey: url as NSCopying)
                }
                }.resume()
            */
        }
        
        
        
        
    }
    func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFill) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func addEventListener(selector:Selector, target:UIView)
    {
        self.addTarget(target, action: selector, for: UIControl.Event.touchUpInside)
    }
    
    private struct custom_properties
    {
        public var hasImage:Bool = false
        public var cImage:UIImage!
    }
    
    func enable()
    {
        self.isUserInteractionEnabled = true
        self.alpha = 1.0
    }
    
    func disable()
    {
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
    }
    
    func setUnderline(text: String, color:UIColor)
    {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, text.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
    
    func setUnderlineDashed(text: String, color:UIColor)
    {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        //titleString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: NSMakeRange(0, text.count))
        titleString.addAttribute(.underlineColor, value: color, range: NSMakeRange(0, text.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
    
    /*
     var hasImage: Bool { // cat is *effectively* a stored property
     get {
     return associatedObject(self, key: &catKey)
     { return "" } // Set the initial value of the var
     }
     set { associateObject(self, key: &catKey, value: newValue) }
     }
     
     */
    
    /*
     public var hasImage:Bool = false
     public var cImage:UIImage = nil
     */
    /*
     var hasImage:Bool?
     {
     get{
     return custom_properties.hasImage
     }
     set(newValue)
     {
     custom_properties.hasImage = newValue!
     }
     }
     
     
     var cImage:UIImage?
     {
     get{
     return custom_properties.cImage
     }
     set(newValue)
     {
     custom_properties.cImage = newValue!
     }
     }
     */
    
//    func underlineButton(text: String)
//    {
//            let titleString = NSMutableAttributedString(string: text)
//        titleString.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleSingle.rawValue, range: NSMakeRange(0, text.count))
//        self.setAttributedTitle(titleString, for: .normal)
//    }
}

public extension UIDevice {

    /// pares the deveice name as the standard name
    var modelName: String {

        #if targetEnvironment(simulator)
            let identifier = ProcessInfo().environment["SIMULATOR_MODEL_IDENTIFIER"]!
        #else
            var systemInfo = utsname()
            uname(&systemInfo)
            let machineMirror = Mirror(reflecting: systemInfo.machine)
            let identifier = machineMirror.children.reduce("") { identifier, element in
                guard let value = element.value as? Int8, value != 0 else { return identifier }
                return identifier + String(UnicodeScalar(UInt8(value)))
            }
        #endif

        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPod9,1":                                 return "iPod touch (7th generation)"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4", "iPhone11,6":                return "iPhone XS Max"
        case "iPhone11,8":                              return "iPhone XR"
        case "iPhone12,1":                              return "iPhone 11"
        case "iPhone12,3":                              return "iPhone 11 Pro"
        case "iPhone12,5":                              return "iPhone 11 Pro Max"
        case "iPhone12,8":                              return "iPhone SE (2nd generation)"
        case "iPhone13,1":                              return "iPhone 12 mini"
        case "iPhone13,2":                              return "iPhone 12"
        case "iPhone13,3":                              return "iPhone 12 Pro"
        case "iPhone13,4":                              return "iPhone 12 Pro Max"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro (12.9-inch) (2nd generation)"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro (10.5-inch)"
        case "iPad8,1", "iPad8,2", "iPad8,3", "iPad8,4":return "iPad Pro (11-inch)"
        case "iPad8,5", "iPad8,6", "iPad8,7", "iPad8,8":return "iPad Pro (12.9-inch) (3rd generation)"
        case "iPad8,11", "iPad8,12":                    return "iPad Pro (12.9-inch) (4th generation)"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        default:                                        return identifier
        }
    }
}

extension String
{
    
    func is18() -> Bool
    {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            if let birthDate = dateFormatter.date(from: self) {
                let calendar = Calendar.current
                if let age = calendar.dateComponents([.year], from: birthDate, to: Date()).year {
                    return age >= 18
                }
            }
            
            return false
    }
    
    var html: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func chopPrefix(_ count: Int = 1) -> String {
        return substring(from: index(startIndex, offsetBy: count))
    }
    
    func chopSuffix(_ count: Int = 1) -> String {
        return substring(to: index(endIndex, offsetBy: -count))
    }
    
    func trim() -> String { return trimmingCharacters(in: CharacterSet.whitespaces) }
    
    var mongoDate:Date {
        let formatter = DateFormatter()
        
        //Format 1
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        if let parsedDate = formatter.date(from:self) {
            return parsedDate
        }
        
        //Format 2
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:SSSZ"
        if let parsedDate = formatter.date(from:self) {
            return parsedDate
        }
        
        
        
        //Format 3
        formatter.dateFormat = "yyyy-MM-ddTHH:mm:SSSZ"
        if let parsedDate = formatter.date(from:self) {
            return parsedDate
        }
        
        //Couldn't parsed with any format. Just get the date
        let splitedDate =  self.components(separatedBy: "T")
        if splitedDate.count > 0 {
            formatter.dateFormat = "yyyy-MM-dd"
            if let parsedDate = formatter.date(from:splitedDate[0]) {
                return parsedDate
            }
        }
        
        // Nothing worked!
        return Date()
    }
    
    
    
    subscript (i: Int) -> Character {
        return Array(self)[i]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String
    {
        //let start = startIndex.
        //let end = start.advancedBy(r.endIndex - r.startIndex)
        
        let start = self.index(self.startIndex, offsetBy: r.lowerBound)
        let end = self.index(self.startIndex, offsetBy: r.upperBound)
        let range = start..<end
        
        return String(self[range])//self[Range(start ..< end)]
    }
    var digits: String
    {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    func removingWhitespaces() -> String
    {
        return self.trimmingCharacters(in: .whitespaces).components(separatedBy: .whitespaces).joined()
    }
    
    
    func isValidEmail() -> Bool
    {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
   
    func currencyFormat() -> String
    {
        
        var number: NSNumber!
        let formatter = NumberFormatter()
        formatter.numberStyle = .currencyAccounting
        formatter.currencySymbol = "$"
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        
        var amountWithPrefix = self
        
        // remove from String: "$", ".", ","
        let regex = try! NSRegularExpression(pattern: "[^0-9]", options: .caseInsensitive)
        amountWithPrefix = regex.stringByReplacingMatches(in: amountWithPrefix, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count), withTemplate: "")
        
        let double = (amountWithPrefix as NSString).doubleValue
        number = NSNumber(value: (double / 100))
        
        // if first number is 0 or all numbers were deleted
        guard number != 0 as NSNumber else {
            return ""
        }
        
        return formatter.string(from: number)!
    }
}



class CurrencyField: UITextField {
    var string: String { return text ?? "" }
    var decimal: Decimal {
        return string.decimal /
            pow(10, Formatter.currency.maximumFractionDigits)
    }
    var decimalNumber: NSDecimalNumber { return decimal.number }
    var doubleValue: Double { return decimalNumber.doubleValue }
    var integerValue: Int { return decimalNumber.intValue   }
    let maximum: Decimal = 999_999_999.99
    private var lastValue: String?
    override func willMove(toSuperview newSuperview: UIView?) {
        // you can make it a fixed locale currency if needed
        // Formatter.currency.locale = Locale(identifier: "pt_BR") // or "en_US", "fr_FR", etc
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .left
        editingChanged(self)
    }
    override func deleteBackward() {
        text = string.digitss.dropLast().lowercased()
     
        editingChanged(self)
    }
    @objc func editingChanged(_ textField: UITextField) {
        guard decimal <= maximum else {
            text = lastValue
            return
        }
        text = Formatter.currency.string(for: decimal)
        lastValue = text
    }
}

extension NumberFormatter {
    convenience init(numberStyle: Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}
extension Formatter {
    static let currency = NumberFormatter(numberStyle: .currency)
}
extension String {
    var digitss: String { return filter(("0"..."9").contains) }
    var decimal: Decimal { return Decimal(string: digits) ?? 0 }
}
extension Decimal {
    var number: NSDecimalNumber { return NSDecimalNumber(decimal: self) }
}
extension UITextView
    
{
    func setItalic() {
           let attributedString = NSMutableAttributedString(attributedString: self.attributedText)
           let range = NSMakeRange(0, attributedString.length)
           attributedString.addAttribute(.font, value: UIFont.italicSystemFont(ofSize: self.font?.pointSize ?? UIFont.systemFontSize), range: range)
           self.attributedText = attributedString
       }
    
    func autoFit()
    {
        let fixedWidth = self.frame.size.width
        self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.frame = newFrame;
        //print(" text height : \(self.frame.size.height)")
    }
}

extension Date
{
    
    func formatDate() -> String
    {
            let outputDateFormatter = DateFormatter()
            outputDateFormatter.dateFormat = "MM/dd/yyyy"
            return outputDateFormatter.string(from: self)
    }
    
    public func timeAgo(numericDates:Bool=false) -> String {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([.minute,.hour,.day,.weekOfYear,.month,.year,.second])
        let now = Date()
        let earliest = now < self ? now: self
        let latest = (earliest == now) ? self : now
        let components:DateComponents = calendar.dateComponents(unitFlags, from: earliest, to: latest)
        
        if components.year! >= 2 {
            return "\(components.year!) years ago"
        }
        else if components.year! >= 1 {
            if numericDates {
                return "1 year ago"
            }
            else {
                return "Last year"
            }
        }
        else if components.month! >= 2 {
            return "\(components.month!) months ago"
        }
        else if components.month! >= 1 {
            if numericDates {
                return "1 month ago"
            }
            else {
                return "Last month"
            }
        }
        else if components.weekOfYear! >= 2 {
            return "\(components.weekOfYear!) weeks ago"
        }
        else if components.weekOfYear! >= 1 {
            if numericDates {
                return "1 week ago"
            }
            else {
                return "Last week"
            }
        }
        else if components.day! >= 2 {
            return "\(components.day!) days ago"
        }
        else if components.day! >= 1 {
            if numericDates {
                return "1 day ago"
            }
            else {
                return "Yesterday"
            }
        }
        else if components.hour! >= 2 {
            return "\(components.hour!) hours ago"
        }
        else if components.hour! >= 1 {
            if numericDates {
                return "1 hour ago"
            }
            else {
                return "An hour ago"
            }
        }
        else if components.minute! >= 2 {
            return "\(components.minute!) minutes ago"
        }
        else if components.minute! >= 1 {
            if numericDates {
                return "1 minute ago"
            }
            else {
                return "A minute ago"
            }
        }
        else if components.second! >= 3 {
            return "\(components.second!) seconds ago"
        }
        else {
            return "Just now"
        }
        
    }
    
}



extension UITextField
{
    func paddingLeft(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func paddingRight(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

extension UITextView
{
    func sizeToWidth( fixedWidth:CGFloat)
    {
        self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        var newFrame = self.frame
        newFrame.size = CGSize(width: max(newSize.width, fixedWidth), height: newSize.height)
        self.frame = newFrame;
    }
}


/*
 
 
 let btnCancel = sharedData.getBtnCancel()
 btnCancel.addTarget(self, action: #selector(self.exitPage), for: UIControlEvents.touchUpInside)
 topBar.addSubview(btnCancel)
 
 
 
 
 
 
 
 var sharedData:SharedData!
 var mainDict:NSMutableDictionary!
 
 
 override init(style: UITableViewCellStyle, reuseIdentifier: String?)
 {
 super.init(style: style, reuseIdentifier: reuseIdentifier)
 sharedData = SharedData.sharedInstance
 
 mainDict = NSMutableDictionary()
 
 
 
 }
 
 func loadData()
 {
 
 }
 
 
 
 required init?(coder aDecoder: NSCoder)
 {
 fatalError("init(coder:) has not been implemented")
 }
 
 override func awakeFromNib()
 {
 super.awakeFromNib()
 // Initialization code
 }
 
 override func setSelected(_ selected: Bool, animated: Bool)
 {
 super.setSelected(selected, animated: animated)
 
 // Configure the view for the selected state
 }
 
 NotificationCenter.default.addObserver(self, selector: #selector(self.showDashboard), name: NSNotification.Name(rawValue: "SHOW_DASHBOARD"), object: nil);
 
 NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SHOW_DASHBOARD"), object: nil)
 
 UIView.animate(withDuration: 0.25)
 {
 
 }
 
 UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations:
 {
    
 }, completion: {
 finished in
    
 })
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 import UIKit
 
 class SignUp:UIView, UITextFieldDelegate
 {
     var sharedData:SharedData!
     
     
     
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
    }
     
     func initClass()
     {
     
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
 
 
 
 
 import UIKit

 class SideMenu:UIView, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource
 {
     var sharedData:SharedData!
     
     var studioImg:UIImageView!
     var custImg:UIImageView!
     
     var mainCon:UIView!
     
     var feedList:UITableView!
     
     var mainDataA:NSMutableArray = NSMutableArray()
     var iconsA:NSMutableArray = NSMutableArray()
     
     override init (frame : CGRect)
     {
         super.init(frame : frame)
         sharedData = SharedData.sharedInstance
         backgroundColor = .white
         
         mainCon = UIView(frame: sharedData.fullRect)
         addSubview(mainCon)
         
         
         feedList = UITableView();
         feedList.width = sharedData.screenWidth
         feedList.y = 0
         feedList.height = sharedData.screenHeight - feedList.y
         feedList.backgroundColor = UIColor.clear
         feedList.delegate = self
         feedList.dataSource = self
         feedList.showsVerticalScrollIndicator = false
         feedList.separatorStyle = .none
         feedList.register(SideMenuCell.self, forCellReuseIdentifier: "sidemenu_cell")
         feedList.tableFooterView = UIView(frame: .zero)
         mainCon.addSubview(feedList)
         
     }
     
     func initClass()
     {
     
     }
     
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
     {
         return 60
     }
     
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
     {
         mainDataA.count
     }
     
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
     {
         let cell = MyAccountCell(style: .default, reuseIdentifier: "myaccount_cell")
         
         let title = mainDataA.object(at: indexPath.row) as! String
         cell.accessoryType = .disclosureIndicator
         cell.title.text = title
         cell.title.font = sharedData.normalFont(size: 20)
         cell.image.image = UIImage(named: (iconsA.object(at: indexPath.row) as! String) )?.withRenderingMode(.alwaysTemplate)
         cell.image.tintColor = .black
         
         return cell
     }
     
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
     {
         tableView.deselectRow(at: indexPath, animated: true)
         
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
 
 */

