//
//  ChatCell.swift
//  StudioGuru
//
//  Created by Sunny Clark on 6/19/23.
//
import UIKit

class ChatCell:UITableViewCell
{
    var sharedData:SharedData!
    var mainDict:NSMutableDictionary!
    var title:UILabel!
    var img:UIImageView!
    var badge:UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedData = SharedData.sharedInstance
        backgroundColor = sharedData.bkColor
        
        self.layer.masksToBounds = true
        mainDict = NSMutableDictionary()
        
        img = UIImageView()
        img.backgroundColor = .darkGray
        img.corner(radius: 20)
        img.width = 40
        img.height = 40
        img.x = 10
        img.y = 10
        img.layer.borderColor = UIColor.lightGray.cgColor
        img.layer.borderWidth = 1
        addSubview(img)
        
        title = UILabel()
        title.width = sharedData.screenWidth
        title.y = 15
        title.x = img.posX() + 10
        title.textColor = .black
        title.font = sharedData.normalFont(size: 20)
        title.height = 20
        title.text = ""
        addSubview(title)
        
        let bottomLine = UIView()
        bottomLine.width = sharedData.screenWidth
        bottomLine.height = 1
        bottomLine.y = 59
        bottomLine.backgroundColor = .black
        bottomLine.alpha = 0.15
        addSubview(bottomLine)
        
        
        badge = UIView()
        badge.width = 26
        badge.height = 26
        badge.backgroundColor = sharedData.blue
        badge.x = sharedData.screenWidth - 70
        badge.y = 17
        badge.corner(radius: 13)
        badge.isHidden = true
        addSubview(badge)
        
        //self.selectionStyle = .none
    
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
    
}
