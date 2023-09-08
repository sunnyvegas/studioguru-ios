//
//  SideMenuCell.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/8/23.
//

import UIKit

class SideMenuCell:UITableViewCell
{
    var sharedData:SharedData!
    var mainDict:NSMutableDictionary!
    var title:UILabel!
    var image:UIImageView!
    var line:UIView!
    var badge:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white//sharedData.bkColor
        
        self.layer.masksToBounds = true
        mainDict = NSMutableDictionary()
        
        
        image = UIImageView()
        image.backgroundColor = .clear
        image.width = 30
        image.height = 30
        image.x = 10
        image.y = 10
        addSubview(image)
        
        title = UILabel()
        title.width = sharedData.screenWidth
        title.y = 5
        title.x = image.posX() + 10
        title.textColor = .black//sharedData.gold
        title.font = sharedData.normalFont(size: 22)
        title.height = 35
        title.text = "Menu Option"
        addSubview(title)
        
        line = UIView()
        line.width = sharedData.screenWidth
        line.height = 1
        line.y = 49
        line.backgroundColor = .black
        line.alpha = 0.1
        addSubview(line)
        
        badge = UILabel()
        badge.width = 20
        badge.height = 20
        badge.backgroundColor = sharedData.blue
        badge.textColor = .white
        badge.textAlignment = .center
        badge.corner(radius: 10)
        badge.x = 120
        badge.y = 15
        badge.font = .systemFont(ofSize: 13)
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
