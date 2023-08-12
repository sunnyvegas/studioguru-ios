//
//  PICell.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/11/23.
//

import UIKit

class PICell:UITableViewCell
{
    var sharedData:SharedData!
    var mainDict:NSMutableDictionary!
    
    var title:UILabel!
    var value:UILabel!
    var image:UIImageView!
    var icon:UIImageView!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white//sharedData.bkColor
        
        self.layer.masksToBounds = true
        mainDict = NSMutableDictionary()
        
        title = UILabel()
        title.width = 200
        title.height = 20
        title.x = 10
        title.y = 10
        title.textColor = .black
        title.font = .systemFont(ofSize: 18, weight: .bold)
        addSubview(title)
        
        value = UILabel()
        value.width = 200
        value.height = 20
        value.x = sharedData.screenWidth - 250
        value.y = 20
        value.textColor = .black
        value.textAlignment = .right
        value.font = .systemFont(ofSize: 16, weight: .regular)
        addSubview(value)
        
        image = UIImageView()
        image.width = 60
        image.height = 60
        image.y = 10
        image.corner(radius: 30)
        image.backgroundColor = .white
        image.x = sharedData.screenWidth - 40 - 70
        image.isHidden = true
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.borderWidth = 1
        addSubview(image)
        
        //value
        
        icon = UIImageView()
        icon.width = 30
        icon.height = 30
        icon.x = sharedData.screenWidth - 40
        icon.y = 15
        icon.image = UIImage(named: "icon_next")?.withRenderingMode(.alwaysTemplate)
        icon.tintColor = .lightGray
        addSubview(icon)
        
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
