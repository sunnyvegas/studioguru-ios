//
//  MoreCell.swift
//  StudioGuru
//
//  Created by Sunny Clark on 8/5/23.
//


import UIKit

class MoreCell:UITableViewCell
{
    var sharedData:SharedData!
    var mainDict:NSMutableDictionary!
    var title:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedData = SharedData.sharedInstance
        backgroundColor = .white//sharedData.bkColor
        
        self.layer.masksToBounds = true
        mainDict = NSMutableDictionary()
        
        title = UILabel()
        title.width = sharedData.screenWidth
        title.y = 10
        title.x = 20
        title.textColor = .black//sharedData.gold
        title.font = sharedData.normalFont(size: 20)
        title.height = 35
        title.text = "Menu Option"
        addSubview(title)
        
        let bottomLine = UIView()
        bottomLine.width = sharedData.screenWidth
        bottomLine.height = 1
        bottomLine.y = 59
        bottomLine.backgroundColor = .black
        bottomLine.alpha = 0.1
        addSubview(bottomLine)
        
        
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
