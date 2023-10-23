//
//  Feed.swift
//  StudioGuru
//
//  Created by Sunny Clark on 10/23/23.
//

import UIKit

class FeedPage:BasePage, UITextFieldDelegate,  UITableViewDelegate, UITableViewDataSource, UITextViewDelegate
{
    var sharedData:SharedData!
    
    var feedList:UITableView!
    
    var mainDataA:NSMutableArray!
    
    var mainCon:UIView!
    
    var mainScroll:UIScrollView!
    
    override init (frame : CGRect)
    {
        super.init(frame : frame)
        sharedData = SharedData.sharedInstance
        backgroundColor = UIColor(hex: 0xEEEEEE)
        
        mainDataA = NSMutableArray()
        mainCon = UIView(frame: sharedData.fullRect)
        addSubview(mainCon)
        
        let topBar = sharedData.getTopBarBig(title: "Studio Feed")
        topBar.addMenu()
        addSubview(topBar)
        
        /*
        feedList = UITableView();
        feedList.width = sharedData.screenWidth
        feedList.y = topBar.posY()
        feedList.height = sharedData.screenHeight - feedList.y
        feedList.backgroundColor = UIColor.clear
        feedList.delegate = self
        feedList.dataSource = self
        feedList.showsVerticalScrollIndicator = false
        feedList.separatorStyle = .none
        feedList.register(FeedCell.self, forCellReuseIdentifier: "feed_cell")
        feedList.tableFooterView = UIView(frame: .zero)
        mainCon.addSubview(feedList)
        */
        
        mainScroll = UIScrollView()
        mainScroll.width = sharedData.screenWidth
        mainScroll.y = topBar.posY()
        mainScroll.height = sharedData.screenHeight - mainScroll.y
        mainScroll.showsVerticalScrollIndicator = false
        mainCon.addSubview(mainScroll)
    }
    
    override func initClass()
    {
        loadData()
    }
    
    @objc func loadData()
    {
        mainDataA.removeAllObjects()
        //feedList.reloadData()
        sharedData.getIt(urlString: sharedData.base_domain + "/api-ios/feed/list", params: [:], callback: {
            success, result_dict in
            
            print("response")
            print(result_dict)
            
            DispatchQueue.main.async() { () -> Void in
                
                self.sharedData.feed_badge_label.isHidden = true
                self.sharedData.feed_badge_count = "0"
               
                if(UIApplication.shared.applicationIconBadgeNumber > 0)
                {
                    UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber - 1
                }
                self.sharedData.postEvent(event: "UPDATE_BADGE_COUNT")
            }
           
            //self.sharedData.feed_badge_label.isHidden = true
            
            self.mainDataA.addObjects(from: (result_dict.object(forKey: "result") as! Array<Any>) )
            //self.feedList.reloadData()
            self.renderList()
        })
    }
    
    @objc func renderList()
    {
        mainScroll.removeSubViews()
        
        var lastY:CGFloat = 10
        for i in 0..<mainDataA.count
        {
            let data = (mainDataA.object(at: i) as! NSDictionary)
            
            let whiteCon = UIView()
            whiteCon.width = sharedData.screenWidth - 20
            whiteCon.height = 450
            whiteCon.corner(radius: 5)
            whiteCon.x = 10
            whiteCon.y = lastY
            whiteCon.backgroundColor = .white
            mainScroll.addSubview(whiteCon)
            
            let title = UILabel()
            title.width = sharedData.screenWidth
            title.x = 20
            title.y = 20
            title.textColor = .black
            title.font = .systemFont(ofSize: 22, weight: .bold)
            title.height = 35
            title.text = "01/01/2022 12:00 PM"
            whiteCon.addSubview(title)
            
            
            let dateLabel = UILabel()
            dateLabel.width = whiteCon.width - 10
            dateLabel.height = 15
            dateLabel.font = .systemFont(ofSize: 11, weight: .bold)
            dateLabel.textColor = UIColor(hex: 0x000000)
            dateLabel.alpha = 0.5
            dateLabel.text = "01/01 10:00pm"
            dateLabel.textAlignment = .right
            dateLabel.y = 25
            addSubview(dateLabel)
            whiteCon.addSubview(dateLabel)
            
            let date = (data.object(forKey: "created_at") as! String).mongoDate
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MM/dd h:mm a" // "12/16 12:00 PM"
            let formattedDate = outputFormatter.string(from: date)
            dateLabel.text = formattedDate.lowercased()
            
            let caption = UITextView()
            caption.width = sharedData.screenWidth - 40
            caption.x = 20
            caption.y = title.posY() + 10
            caption.backgroundColor = .clear
        
            caption.textColor = .darkGray
            caption.font = .systemFont(ofSize: 16)
            
            caption.backgroundColor = .clear
            caption.isEditable = false
            caption.isSelectable = true
            caption.linkTextAttributes = [
                .foregroundColor: sharedData.blue!, // Text color for links
                .underlineStyle: NSUnderlineStyle.single.rawValue // Underline style for links
            ]
            caption.isScrollEnabled = false
            caption.dataDetectorTypes = .all
            
            whiteCon.addSubview(caption)
            
            let media_image = UIImageView()
            media_image.x = 20
            media_image.backgroundColor = .black
            media_image.contentMode = .scaleAspectFit
            media_image.layer.masksToBounds = true
            media_image.y = caption.posY() + 10
            media_image.corner(radius: 5)
            media_image.width = sharedData.screenWidth - 40
            media_image.height = (media_image.width/4) * 3
            
            
            title.text = (data.object(forKey: "title") as! String)
         
            //caption.text = (data.object(forKey: "description") as! String)
            caption.attributedText = convertHTMLToAttributedString((data.object(forKey: "description") as! String))
            caption.autoFit()
            
            caption.inputView = UIView()
           
            whiteCon.addSubview(media_image)
            if((data.object(forKey: "photo") as! String) == "")
            {
               media_image.isHidden = true
               //l.media_image.downloadedFrom(link:(data.object(forKey: "media_image") as! String) )
               media_image.y = caption.posY() + 10
               whiteCon.height = caption.posY() + 20
                
                
            }else{
                media_image.isHidden = false
                media_image.downloadedFrom(link:(data.object(forKey: "photo") as! String) )
                media_image.y = caption.posY() + 10
                whiteCon.height = media_image.posY() + 20
            }
            
            lastY = whiteCon.posY() + 10
        }
        
        mainScroll.contentSize = CGSize(width: sharedData.screenWidth, height: lastY + 20)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        
        let data = (mainDataA.object(at: indexPath.row) as! NSDictionary)
        
        
        let whiteCon = UIView()
        whiteCon.width = sharedData.screenWidth - 20
        whiteCon.height = 450
        whiteCon.corner(radius: 5)
        whiteCon.x = 10
        whiteCon.y = 10
        whiteCon.backgroundColor = .white
      
        
        let title = UILabel()
        title.width = sharedData.screenWidth
        title.x = 20
        title.y = 20
        title.textColor = .black
        title.font = UIFont(name: "Avenir-Black", size: 22)
        title.height = 35
        title.text = "01/01/2022 12:00 PM"
       
        
        let caption = UITextView()
        caption.width = sharedData.screenWidth - 40
        caption.x = 20
        caption.y = title.posY() + 10
        caption.backgroundColor = .clear
    
        caption.textColor = .darkGray
        caption.font = UIFont(name: "Avenir-Book", size: 16)
        
        
        let media_image = UIImageView()
        media_image.x = 20
        media_image.backgroundColor = .black
        media_image.contentMode = .scaleAspectFit
        media_image.layer.masksToBounds = true
        media_image.y = caption.posY() + 10
        media_image.corner(radius: 5)
        media_image.width = sharedData.screenWidth - 40
        media_image.height = (media_image.width/4) * 3
        
        
        title.text = (data.object(forKey: "title") as! String)
     
        caption.text = (data.object(forKey: "description") as! String)
        //caption.attributedText = (data.object(forKey: "description") as! String)//convertHTMLToAttributedString((data.object(forKey: "description") as! String))
        caption.autoFit()
        
        caption.inputView = UIView()
       
        if((data.object(forKey: "photo") as! String) == "")
        {
           media_image.isHidden = true
           //l.media_image.downloadedFrom(link:(data.object(forKey: "media_image") as! String) )
           media_image.y = caption.posY() + 10
           whiteCon.height = caption.posY() + 20
            
            
        }else{
            media_image.isHidden = false
            media_image.downloadedFrom(link:(data.object(forKey: "photo") as! String) )
            media_image.y = caption.posY() + 10
            whiteCon.height = media_image.posY() + 20
        }
        
        
        return whiteCon.posY()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        mainDataA.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = FeedCell(style: .default, reuseIdentifier: "feed_cell")
        
        
        let data = (mainDataA.object(at: indexPath.row) as! NSDictionary)
        //let title = mainDataA.object(at: indexPath.row) as! String
        
        cell.title.text = (data.object(forKey: "title") as! String)
     
        cell.caption.text = (data.object(forKey: "description") as! String)
        cell.caption.isSelectable = true
        cell.caption.delegate = self
       
        
        
        let date = (data.object(forKey: "created_at") as! String).mongoDate
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "MM/dd h:mm a" // "12/16 12:00 PM"
        let formattedDate = outputFormatter.string(from: date)
        cell.dateLabel.text = formattedDate.lowercased()
        
        cell.caption.autoFit()
        
        if((data.object(forKey: "photo") as! String) == "")
        {
            cell.media_image.isHidden = true
            //cell.media_image.downloadedFrom(link:(data.object(forKey: "media_image") as! String) )
            cell.media_image.y = cell.caption.posY() + 10
            cell.whiteCon.height = cell.caption.posY() + 20
            
            
        }else{
            cell.media_image.isHidden = false
            cell.media_image.downloadedFrom(link:(data.object(forKey: "photo") as! String) )
            cell.media_image.y = cell.caption.posY() + 10
            cell.whiteCon.height = cell.media_image.posY() + 20
        }
        
        
        
        
        return cell
    }
    
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//            // You can perform custom actions when a link is tapped.
//            // For example, open the URL in a browser.
//            UIApplication.shared.open(URL)
//            return false
//        }
    
    func convertHTMLToAttributedString(_ html: String) -> NSAttributedString? {
           guard let data = html.data(using: .utf8) else { return nil }
           do {
               let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [
                   .documentType: NSAttributedString.DocumentType.html,
                   .characterEncoding: String.Encoding.utf8.rawValue
               ]
               let attributedString = try NSMutableAttributedString(data: data, options: options, documentAttributes: nil)
               
               
               attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 16), range: NSRange(location: 0, length: attributedString.length))
               
               return attributedString
           } catch {
               print("Error converting HTML to attributed string: \(error)")
               return nil
           }
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
