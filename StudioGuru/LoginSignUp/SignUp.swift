//
//  SignUp.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//


import UIKit

class SignUp:UIView, UITextFieldDelegate
{
    var sharedData:SharedData!
    
    var mainCon:UIView!
    
    var pagesA:NSMutableArray = NSMutableArray()
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white
        
        pagesA = NSMutableArray()
        
        mainCon = UIView(frame: sharedData.fullRect)
        mainCon.width = sharedData.screenWidth * 11
        addSubview(mainCon)
        
        
//
//        let page1 = SignUpInfo(frame: sharedData.fullRect)
//        let page2 = SignUpAccount(frame: sharedData.fullRect)
//        let page3 = SignUpPhoto(frame: sharedData.fullRect)
//        let page4 = SignUpVideo(frame: sharedData.fullRect)
//
//        let page5 = SignUpWhy(frame: sharedData.fullRect)
//        let page6 = SignUpExpertise(frame: sharedData.fullRect)
//        let page7 = SignUpExperience(frame: sharedData.fullRect)
//        let page8 = SignUpWebLink(frame: sharedData.fullRect)
//        let page9 = SignUpDonationLink(frame: sharedData.fullRect)
//
//
//
//        mainCon.addSubview(page1)
//
//
//
//        pagesA.add(page1)

        
        
      
        
        sharedData.addEventListener(title: "SIGNUP_UPDATE_PAGES", target: self, selector: #selector(self.updatePages))
        sharedData.addEventListener(title: "SIGNUP_EXIT", target: self, selector: #selector(self.goExit))
    }
    
    func initClass()
    {
    
    }
    
    @objc func updatePages()
    {
        
        let page = (pagesA.object(at: Int(sharedData.cSignUpPage) ) as! BasePage)
        page.initClass()

        UIView.animate(withDuration: 0.25)
        {
            self.mainCon.x = self.sharedData.screenWidth * self.sharedData.cSignUpPage * -1
        }
        
        //mainScroll.setContentOffset(CGPoint(x: sharedData.screenWidth * sharedData.cSignUpPage, y: 0), animated: true)
    }
    
    @objc func goExit()
    {
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
