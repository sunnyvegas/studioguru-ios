//
//  FeedCell.swift
//  StudioGuru
//
//  Created by Sunny Clark on 10/23/23.
//

import UIKit


class FeedCell:UITableViewCell
{
    var sharedData:SharedData!
    var mainDict:NSMutableDictionary!
    var title:UILabel!
    var caption:UITextView!
    var media_image:UIImageView!
    var whiteCon:UIView!
    var dateLabel:UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        sharedData = SharedData.sharedInstance
        backgroundColor = .clear
        
        self.layer.masksToBounds = true
        mainDict = NSMutableDictionary()
        
        whiteCon = UIView()
        whiteCon.width = sharedData.screenWidth - 20
        whiteCon.height = 450
        whiteCon.corner(radius: 5)
        whiteCon.x = 10
        whiteCon.y = 10
        whiteCon.backgroundColor = .white
        addSubview(whiteCon)
        
        title = UILabel()
        title.width = sharedData.screenWidth
        title.x = 20
        title.y = 20
        title.textColor = .black
        title.font = UIFont(name: "Avenir-Black", size: 22)
        title.height = 35
        title.text = "01/01/2022 12:00 PM"
        addSubview(title)
        
        dateLabel = UILabel()
        dateLabel.width = whiteCon.width - 10
        dateLabel.height = 15
        dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
        dateLabel.textColor = UIColor(hex: 0x000000)
        dateLabel.alpha = 0.5
        dateLabel.text = "01/01 10:00pm"
        dateLabel.textAlignment = .right
        dateLabel.y = 25
        addSubview(dateLabel)
        
        
        
        
        caption = UITextView()
        caption.width = sharedData.screenWidth - 40
        caption.x = 20
        caption.y = title.posY() + 10
        caption.backgroundColor = .clear
        caption.isEditable = false
        caption.isSelectable = true
        caption.linkTextAttributes = [
            .foregroundColor: sharedData.blue!, // Text color for links
            .underlineStyle: NSUnderlineStyle.single.rawValue // Underline style for links
        ]
        caption.dataDetectorTypes = .all
    
        caption.textColor = .darkGray
        caption.font = .systemFont(ofSize: 16)
        addSubview(caption)
        
        media_image = UIImageView()
        media_image.x = 20
        media_image.backgroundColor = .black
        media_image.contentMode = .scaleAspectFit
        media_image.layer.masksToBounds = true
        media_image.y = caption.posY() + 10
        media_image.corner(radius: 5)
        media_image.width = sharedData.screenWidth - 40
        media_image.height = (media_image.width/4) * 3
        addSubview(media_image)
        /*
        let bottomLine = UIView()
        bottomLine.width = sharedData.screenWidth
        bottomLine.height = 1
        bottomLine.y = 59
        bottomLine.backgroundColor = .white
        bottomLine.alpha = 0.25
        addSubview(bottomLine)
        */
        
        self.selectionStyle = .none
    
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
