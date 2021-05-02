//
//  MasterDetailController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore


class MasterDetailController: UIViewController {
    var data_id:String!
    var databaseRef: DatabaseReference!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var goChatBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseRef = Database.database().reference().child("my/master/\(data_id!)")
        databaseRef?.observeSingleEvent(of: .value, with: {(snapshot) in
            let key = snapshot.key
            let value = snapshot.value as? NSDictionary
            let location = value?["location"] as? String ?? ""
            let content = value?["content"] as? String ?? ""
            self.locationLabel?.text = location
            self.contentLabel?.text = content
            self.contentLabel?.sizeToFit()
            self.contentLabel?.numberOfLines = 0
            self.contentLabel.lineBreakStrategy = .hangulWordPriority
            let image_url = value?["image_url"] as? String
            let url = URL(string: image_url!)!
            let data = try? Data(contentsOf: url)
            self.imageView.image = UIImage(data: data!)
        })
        goChatBtn.layer.cornerRadius = 20
        
        
    }
    
}
