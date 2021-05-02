//
//  BoardDetailViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class BoardDetailViewController: UIViewController {
    var data_id:String!
    var databaseRef: DatabaseReference!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var uploadImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileImageView.layer.cornerRadius =  profileImageView.layer.frame.size.width / 2
        
        
        
        databaseRef = Database.database().reference().child("my/freeboard/\(data_id!)")
        databaseRef?.observeSingleEvent(of: .value, with: {(snapshot) in
            let key = snapshot.key
            let value = snapshot.value as? NSDictionary
            let title = value?["title"] as? String ?? ""
            let content = value?["content"] as? String ?? ""
            self.titleLabel?.text = title
            self.contentLabel?.text = content
            self.contentLabel?.sizeToFit()
            self.contentLabel?.numberOfLines = 0
            self.contentLabel.lineBreakStrategy = .hangulWordPriority
            let image_url = value?["image_url"] as? String
            let url = URL(string: image_url!)!
            let data = try? Data(contentsOf: url)
            self.imageView.image = UIImage(data: data!)
            
        })
    }
}

