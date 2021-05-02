//
//  InsideSearchViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/02/08.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class InsideSearchViewController: UIViewController {
    var data_id:String!
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemBackground
        
//        databaseRef = Database.database().reference().child("my/search/\(data_id!)")
//        databaseRef?.observeSingleEvent(of: .value, with: {(snapshot) in
//            let key = snapshot.key
//            let value = snapshot.value as? NSDictionary
//            let location = value?["location"] as? String ?? ""
//            let content = value?["content"] as? String ?? ""
//            let image_url = value?["image_url"] as? String
//            let url = URL(string: image_url!)!
//            let data = try? Data(contentsOf: url)
//           // self.imageView.image = UIImage(data: data!)
//
//        })
    }
}
