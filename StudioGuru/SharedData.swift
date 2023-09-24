//
//  SharedData.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//



import UIKit
import Alamofire
import SocketIO

class SharedData: NSObject
{
    static let sharedInstance = SharedData()
    
    var screenWidth:CGFloat!
    var screenHeight:CGFloat!
    var fullRect:CGRect!
    var fullRectBottom:CGRect!
    
    var imagesDict:NSMutableDictionary!
    
    var keyboardHeight:CGFloat = 0
    
    var edit_valuesA:NSMutableArray = NSMutableArray()
    
    var blue:UIColor!
    var green:UIColor!
    var bkColor:UIColor!
    var gray:UIColor!
    
    var cPage:CGFloat!
    
    var cSignUpPage:CGFloat!
    
    var c_image:UIImage!
    var c_vid_url:URL!
    
    var c_image_state:String!
    
    var base_domain:String!
    var domain:String!
    var studio_id:String!
    var studio_name:String!
    
    var member_id:String!
    var member_token:String!
    var member_name:String!
    
    var s_email = ""
    var s_password = ""
    var s_name = ""
    var s_birth_date = ""
    
    var chat_title = ""
    var chat_id = ""
    
    var tmp_chat_title = ""
    var tmp_chat_id = ""
    var canLoadChat = false
    var didOpenFromPush = false
    
    var device_token = ""
    
    var owner:Bool = false
    var manager:Bool = false
    var instructor:Bool = false
    var staff:Bool = false
    
    
    var edit_key = ""
    var edit_title = ""
    var edit_value = ""
    var edit_api = ""
    var edit_event = ""
    var chat_badge_count = ""
    var badge_label:UILabel!
    
    var studentDict:NSMutableDictionary = NSMutableDictionary()
    
    var is_online = false
    
    var support_email = ""
    var email_message = ""
    var email_subject = ""
    
    
    private override init()
    {
        screenWidth = UIScreen.main.bounds.width
        screenHeight = UIScreen.main.bounds.height
        fullRect =  CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: screenWidth, height: screenHeight))
        fullRectBottom =  CGRect(origin: CGPoint(x: 0,y :screenHeight), size: CGSize(width: screenWidth, height: screenHeight))
        imagesDict = NSMutableDictionary()
        
        cSignUpPage = 0
        cPage = 0
      
        member_id = ""
        studio_name = ""
        member_name = ""
        
        base_domain = "https://dev-studiobossapp.herokuapp.com"
        domain = "192.168.0.112"//"dev-studiobossapp.herokuapp.com"
        member_token = ""
        studio_id = "abc"
        blue = UIColor(hex: 0x1187be)
        green = UIColor(hex: 0x2cbe11)
        gray = UIColor(hex: 0x004F98)
        
    }
    
    func getBtnNext(title:String) -> UIButton
    {
        let btnNext = UIButton(type: .roundedRect)
        btnNext.width = self.screenWidth - 40
        btnNext.height = 50
        btnNext.x = 20
        btnNext.titleLabel?.font = self.boldFont(size: 20)
        btnNext.setTitle(title, for: .normal)
        btnNext.setTitleColor(.white, for: .normal)
        btnNext.backgroundColor = self.blue
        btnNext.corner(radius: 10)
        btnNext.layer.borderColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btnNext.layer.borderWidth = 1
        btnNext.y = self.screenHeight - 90
        return btnNext
    }
    
    func addEventListener(title:String, target:NSObject, selector:Selector)
    {
        NotificationCenter.default.addObserver(target,selector:selector, name: NSNotification.Name(rawValue: title), object: nil)
    }
    
    func postEvent(event:String)
    {
        NotificationCenter.default.post(name: NSNotification.Name(event), object: nil)
    }
    
    
    func normalFont(size:CGFloat) -> UIFont
    {
        return UIFont(name: "Roboto-Regular", size: size)!
    }
    
    func boldFont(size:CGFloat) -> UIFont
    {
        return UIFont(name: "Roboto-Medium", size: size)!
    }
    
    func liteFont(size:CGFloat) -> UIFont
    {
        return  UIFont(name: "Roboto-Light", size: size)!
    }
    
    func getTopBarBig(title:String) -> TopBar
    {
        let view = TopBar(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 90))
        view.initClass(title: title)
        return view
    }
    
    func setTimeout(delay:TimeInterval, block:@escaping ()->Void)
    {
        Timer.scheduledTimer(timeInterval: delay, target: BlockOperation(block: block), selector: #selector(Operation.main), userInfo: nil, repeats: false)
    }
    
    func getToolBar(target:NSObject, selector:Selector, title:String = "Done", direction:String = "right") -> UIToolbar
    {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        
  
        toolBar.isTranslucent = true
        //toolBar.tintColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1)
        toolBar.isUserInteractionEnabled = true
        let doneButton = UIBarButtonItem(title: title, style: UIBarButtonItem.Style.plain, target: target, action: selector)
    
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        if(direction == "right")
        {
            toolBar.setItems([ spaceButton, doneButton], animated: false)
        }else
        {
            toolBar.setItems([ doneButton, spaceButton], animated: false)
        }
        toolBar.isUserInteractionEnabled = true
        
        return toolBar
    }
    
    func getUserData(title:String) -> String
    {
        if(UserDefaults.standard.value(forKey: title) != nil)
        {
            return UserDefaults.standard.value(forKey: title) as! String
        }else{
            return ""
        }
    }
    
    
    func getUserObject(title:String) -> Any
    {
        if(UserDefaults.standard.value(forKey: title) != nil)
        {
            return UserDefaults.standard.value(forKey: title)!
        }else{
            return ""
        }
    }
    
    func setUserData(key:String, value:Any)
    {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func isValidEmail(_ email: String) -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func showMessage(title:String, message:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        let window = UIApplication.shared.keyWindow
        
        window?.rootViewController!.present(alertController, animated: true) {
            // ...
        }
    }
    
    func showMessageCBConfirm(title:String,message:String, callbackY: @escaping () -> Void, callbackN: @escaping () -> Void)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Yes", style: .default) { (action) in
            // ...
            callbackY()
        }
        alertController.addAction(OKAction)
        
        
        let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
            // ...
            callbackN()
        }
        alertController.addAction(noAction)
        
        
        
        let window = UIApplication.shared.keyWindow
        
        window?.rootViewController!.present(alertController, animated: true) {
            // ...
        }
    }
    
    func showMessageConfirm(title:String,message:String, callbackY: @escaping () -> Void)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            // ...
            callbackY()
        }
        alertController.addAction(OKAction)
        
        
    
        
        
        let window = UIApplication.shared.keyWindow
        
        window?.rootViewController!.present(alertController, animated: true) {
            // ...
        }
    }
    
    func formatPhone(with mask: String, phone: String) -> String
    {
        let numbers = phone.replacingOccurrences(of: "[^0-9]", with: "", options: .regularExpression)
        var result = ""
        var index = numbers.startIndex // numbers iterator

        // iterate over the mask characters until the iterator of numbers ends
        for ch in mask where index < numbers.endIndex {
            if ch == "X" {
                // mask requires a number in this place, so take the next one
                result.append(numbers[index])

                // move numbers iterator to the next index
                index = numbers.index(after: index)

            } else {
                result.append(ch) // just append a mask character
            }
        }
        return result
    }
    
    func getIt(urlString:String, params:[String:Any], callback: @escaping (_ success:Bool, _ result:NSDictionary) -> Void)
    {
        
        let urlToSend = urlString
        //AF.request(URLRequestConvertible).responseJSON(completionHandler: ()->{})
        let cookieProps =
        [
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "member_token",
            HTTPCookiePropertyKey.value: member_token!
        ]
        let cookie = HTTPCookie(properties: cookieProps as [HTTPCookiePropertyKey : Any])!
        AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        
        
        let cookiePropsId =
        [
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "member_id",
            HTTPCookiePropertyKey.value: member_id!
        ]
        let cookieId = HTTPCookie(properties: cookiePropsId as [HTTPCookiePropertyKey : Any])!
        AF.session.configuration.httpCookieStorage?.setCookie(cookieId)
        
        let headers : HTTPHeaders = ["x-access-token": ""]
        
        print("urlToSend----->",urlToSend)
        print("member_id-",member_id!)
        print("member_token-",member_token!)
        print("cookie----->",cookie)
        //AF.request(urlToSend, method: .get, parameters: params, encoding:URLEncoding.default , headers: headers, interceptor: nil).response { (responseData) in
           
        AF.request( urlToSend, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON (queue: DispatchQueue.global(qos: .background)){ (response) in
            
            
            switch response.result
            {
                case let .success(value):
                    print("value")
                    print(value)
                    let dict = value as! NSDictionary
                    DispatchQueue.main.async()
                    {
                        callback(true,dict)
                    }
                case .failure(_):
                    callback(false, NSDictionary())
            }
        }
        
     
        
      
    }
    
    func checkChatCount()
    {
        if(member_id != "")
        {
            getIt(urlString: base_domain + "/api-ios/chat/count", params: [:], callback:
            {
                success, result_dict in
                
                let count = (result_dict.object(forKey: "result") as! Int)
                UIApplication.shared.applicationIconBadgeNumber = count
                self.badge_label.isHidden = (count == 0)
              
            })
        }
    }
    
    func postIt(urlString:String, params:[String:Any], callback: @escaping (_ success:Bool, _ result:NSDictionary) -> Void)
    {
        
        let urlToSend = urlString
        //AF.request(URLRequestConvertible).responseJSON(completionHandler: ()->{})
        let cookieProps =
        [
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "member_token",
            HTTPCookiePropertyKey.value: member_token
        ]
        let cookie = HTTPCookie(properties: cookieProps as [HTTPCookiePropertyKey : Any])!
        AF.session.configuration.httpCookieStorage?.setCookie(cookie)
        
        
        let cookiePropsId =
        [
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "member_id",
            HTTPCookiePropertyKey.value: member_id
        ]
        let cookieId = HTTPCookie(properties: cookiePropsId as [HTTPCookiePropertyKey : Any])!
        AF.session.configuration.httpCookieStorage?.setCookie(cookieId)
        
        
        //member_id
        
        
        print("cookie----->",cookie)
        //AF.setCookies(HTTPCookie(properties: cookieProps), for: urlToSend, mainDocumentURL: nil)
        //Alamofire.Manager.sharedInstance.session.configuration.HTTPCookieStorage?.setCookies(cookies, forURL: response.URL!, mainDocumentURL: nil)
            //AFDataResponse.data?.values
        AF.request( urlToSend, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON (queue: DispatchQueue.global(qos: .background)){ (response) in
            
            switch response.result
            {
                case let .success(value):
                    print(value)
                    let dict = value as! NSDictionary
                    DispatchQueue.main.async()
                    {
                        callback(true,dict)
                    }
                case  .failure(_):
                    callback(false, NSDictionary())
            }
        }
        
        
    }
    
    func postItWithFile(urlString:String, params:[String:Any], filesA:NSMutableArray ,callback: @escaping (_ success:Bool, _ result:NSDictionary) -> Void)
    {
        
       
        
        //AF.upload(<#T##stream: InputStream##InputStream#>, to: <#T##URLConvertible#>)
        
        /*
        let cookieProps =
        [
            HTTPCookiePropertyKey.domain: domain,
            HTTPCookiePropertyKey.path: "/",
            HTTPCookiePropertyKey.name: "member_token",
            HTTPCookiePropertyKey.value: member_token
        ]
        let cookie = HTTPCookie(properties: cookieProps as [HTTPCookiePropertyKey : Any])!
        */
        
        let api_url = urlString
            guard let url = URL(string: api_url) else {
                return
            }

            var urlRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0 * 1000)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")
            AF.upload(multipartFormData: { multiPart in
                
                for i in 0..<filesA.count
                {
                    let dict = filesA.object(at: i) as! NSDictionary
                    //var data:Any!
                    let file_name = dict.object(forKey: "file_name") as! String
                    let fileName = dict.object(forKey: "fileName") as! String
                    let mimeType = dict.object(forKey: "mimeType") as! String
                    
                    if(file_name == "file")
                    {
                        let data = dict.object(forKey: "data") as! Data
                        multiPart.append(data, withName: file_name, fileName: fileName, mimeType: mimeType)
                    }else{
                        let data = dict.object(forKey: "data") as! URL//self.videoURL
                        multiPart.append(data, withName: file_name, fileName: fileName, mimeType: mimeType)
                    }
                    
                    
                }
                
                
               
                //multiPart.append(imgData, withName: "file", fileName: "file.png", mimeType: "image/png")
            }, with: urlRequest)
                .uploadProgress(queue: .main, closure: { progress in
                    //Current upload progress of file
                    print("Upload Progress: \(progress.fractionCompleted)")
                })
                .responseJSON(completionHandler: { data in

                           switch data.result {

                           case .success(_):
                            do {
                            
                            let dictionary = try JSONSerialization.jsonObject(with: data.data!, options: .fragmentsAllowed) as! NSDictionary
                              
                                print("Success!")
                                print(dictionary)
                                
                                DispatchQueue.main.async()
                                {
                                    callback(true,dictionary)
                                }
                                
                                
                           }
                           catch {
                              // catch error.
                            print("catch error")

                                  }
                            break
                                
                           case .failure(_):
                            print("failure")

                            break
                            
                        }


                })
        
        
        
        
    }
    
}
