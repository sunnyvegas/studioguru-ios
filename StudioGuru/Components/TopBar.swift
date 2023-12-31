//
//  TopBar.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/10/23.
//



import UIKit


class TopBar: UIView
{
    
    var sharedData:SharedData!
    
    var titleLabel:UILabel!
    
    var line:UIView!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)

        sharedData = SharedData.sharedInstance
        //backgroundColor = UIColor(hex: 0x00919E)
        backgroundColor = sharedData.gray
        
        titleLabel = UILabel(frame: CGRect(x: 0, y: 40, width: sharedData.screenWidth, height: 40))
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        //titleLabel.font = .systemFont(ofSize: 25)
        addSubview(titleLabel)
        titleLabel.backgroundColor = UIColor.clear
        
        line = UIView()
        line.width = sharedData.screenWidth
        line.height = 1
        line.alpha = 0.5
        line.backgroundColor = UIColor.white
        line.y = frame.size.height - 1
       // addSubview(line)
    }
    
    func initClass(title:String)
    {
        titleLabel.textAlignment = .center
        titleLabel.text = title
        titleLabel.font = sharedData.boldFont(size: 25)
        titleLabel.textColor = .white
    }
    
    @objc func addExit(selector:Selector, target:UIView)
    {
        let btnExit = UIButton(type: .custom)
        btnExit.width = 50
        btnExit.height = 50
        btnExit.y = 35
        btnExit.addEventListener(selector: selector, target: target)
        btnExit.setImage(UIImage(named: "icon_x"), for: .normal)
        addSubview(btnExit)
    }
    
    @objc func addExitRight(selector:Selector, target:UIView)
    {
        let btnExit = UIButton(type: .custom)
        btnExit.width = 50
        btnExit.height = 50
        btnExit.y = 35
        btnExit.x = sharedData.screenWidth - 60
        btnExit.addEventListener(selector: selector, target: target)
        btnExit.setImage(UIImage(named: "icon_x"), for: .normal)
        addSubview(btnExit)
    }
    
    @objc func addBack(selector:Selector, target:UIView)
    {
        let btnExit = UIButton(type: .custom)
        btnExit.width = 50
        btnExit.height = 50
        btnExit.y = 35
        btnExit.addEventListener(selector: selector, target: target)
        btnExit.setImage(UIImage(named: "icon_back"), for: .normal)
        addSubview(btnExit)
    }
    
    @objc func addPlus(selector:Selector, target:UIView)
    {
        let btnExit = UIButton(type: .custom)
        btnExit.width = 40
        btnExit.height = 40
        btnExit.y = 40
        btnExit.x = sharedData.screenWidth - 50
        btnExit.addEventListener(selector: selector, target: target)
        btnExit.setImage(UIImage(named: "icon_plus"), for: .normal)
        addSubview(btnExit)
    }
    
    @objc func addMenu()
    {
        let btnExit = UIButton(type: .custom)
        btnExit.width = 50
        btnExit.height = 50
        btnExit.y = 35
        btnExit.addEventListener(selector: #selector(self.openMenu ), target: self)
        btnExit.setImage(UIImage(named: "icon_more")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnExit.imageView?.tintColor = .white
        addSubview(btnExit)
        titleLabel.x = 0
        titleLabel.textAlignment = .center
    }
    
    @objc func openMenu()
    {
        sharedData.postEvent(event: "TOGGLE_MENU")
    }
    
    @objc func addSetting(selector:Selector, target:UIView)
    {
        let btnExit = UIButton(type: .custom)
        btnExit.width = 40
        btnExit.height = 40
        btnExit.y = 40
        btnExit.x = sharedData.screenWidth - 50
        btnExit.addEventListener(selector: selector, target: target)
        btnExit.setImage(UIImage(named: "icon_dots"), for: .normal)
        addSubview(btnExit)
    }
    
    
    convenience init () {
        self.init(frame:CGRect.zero)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
    
}

