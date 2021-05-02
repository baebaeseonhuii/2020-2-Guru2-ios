//
//  VolunteerDetailViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/02/03.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import FirebaseFirestore


class VolunteerDetailViewController: UIViewController {
    var data_id: String!
    var storageRef:StorageReference!
    var databaseRef: DatabaseReference!
    let storage = Storage.storage()
    var url : URL!
    
    let db = Firestore.firestore()
    private let database = Database.database().reference()
    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var houseNameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var peopleNumLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    @IBOutlet weak var partBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "이 달의 봉사"
        
        databaseRef = Database.database().reference().child("my/volunteer/board/\(data_id!)")
        databaseRef?.observeSingleEvent(of: .value, with: {(snapshot) in
            let key = snapshot.key
            let value = snapshot.value as? NSDictionary
            let location = value?["location"] as? String ?? ""
            let date = value?["date"] as? String ?? ""
            let houseName = value?["houseName"] as? String ?? ""
            let peopleNum = value?["peopleNum"] as? String ?? ""
            let content = value?["content"] as? String ?? ""
            self.houseNameLabel?.text = houseName
            self.locationLabel?.text = location
            self.dateLabel?.text = date
            self.peopleNumLabel?.text = peopleNum
            self.contentLabel?.text = content
            self.contentLabel?.sizeToFit()
            self.contentLabel?.numberOfLines = 0
            self.contentLabel.lineBreakStrategy = .hangulWordPriority
            let image_url = value?["image_url"] as? String
            self.url = URL(string:image_url!)!
            let data = try? Data(contentsOf: self.url)
            self.img.image = UIImage(data: data!)
            
        })
        partBtn.layer.cornerRadius = 20
        
    }

    
    @IBAction func Participate(_ sender: Any) {
        print("button clicked")
        
        
        let alertVC = UIAlertController(title: "", message: "신청되었습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
        addNewParticitation()
    }
    
    @objc private func addNewParticitation() {
        
        databaseRef = Database.database().reference().child("my/volunteer/Participate").childByAutoId()
        databaseRef?.setValue(["location": houseNameLabel.text!,
                               "image_url": self.url!.absoluteString
                                     ])
        self.navigationController?.popViewController(animated: true)
        
    }
    
}
