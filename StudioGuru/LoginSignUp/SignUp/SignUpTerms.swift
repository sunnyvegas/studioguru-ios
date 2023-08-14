//
//  SignUpTerms.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/13/23.
//

import UIKit
import WebKit


class SignUpTerms:BasePage, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    
    var webView:WKWebView!
   override init (frame : CGRect)
   {
       super.init(frame : frame)
       sharedData = SharedData.sharedInstance
       backgroundColor = .white
       
       mainCon = UIView(frame: sharedData.fullRect)
       addSubview(mainCon)
       
       let topBar = sharedData.getTopBarBig(title: "Terms")
       topBar.addExit(selector: #selector(self.goExit), target: self)
       addSubview(topBar)
       
       webView = WKWebView(frame: sharedData.fullRect)
       webView.height = sharedData.screenHeight - topBar.height - 110
       webView.y = topBar.posY()
       let url = URL(string: sharedData.base_domain + "/api-terms")!
       webView.load(URLRequest(url: url))
       
   }
    
    override func initClass()
    {
        renderDetails()
    }
    
    @objc func renderDetails()
    {
        mainCon.removeSubViews()
        
        mainCon.addSubview(webView)
        
       
        
        
        let btn = sharedData.getBtnNext(title: "I AGREE")
        btn.y = sharedData.screenHeight - 100
        btn.addEventListener(selector: #selector(self.goNext), target: self)
        mainCon.addSubview(btn)
        
    }
    
    @objc func goNext()
    {
        sharedData.cSignUpPage = 1
        sharedData.postEvent(event: "SIGNUP_UPDATE_PAGES")
    }
    
    @objc func goExit()
    {
        sharedData.postEvent(event: "SIGNUP_EXIT")
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
