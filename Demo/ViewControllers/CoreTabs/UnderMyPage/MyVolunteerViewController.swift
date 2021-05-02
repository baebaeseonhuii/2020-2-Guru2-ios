//
//  MyVolunteerViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class MyVolunteerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var volRef: DatabaseReference?
    
    struct datasource {
        var id : String
        var image: Data
        var title : String
    }
    
    var text_data = [datasource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        volRef = Database.database().reference().child("my/volunteer/Participate")
        volRef?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            print(key)
            guard let value = snapshot.value as? [String : Any] else {return}
            print(value)
            if let title = value["location"] as? String, let image_url = value["image_url"] as? String {
                let url = URL(string: image_url)!
                let image_data = try? Data(contentsOf: url)
                let data = datasource(id: key, image: image_data!, title: title)
                print(data.id)
                self?.text_data.append(data)
                
                if let row = self?.text_data.count {
                    let indexPath = IndexPath(row: row-1, section: 0)
                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
                }
            }
        }
    }
}

extension MyVolunteerViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = text_data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyVolunteerCell", for: indexPath) as! MyVolunteerCell
        
        cell.MyVolunteerImg?.image = UIImage(data: data.image)
        cell.MyVolunteerTitle.text = data.title
        
        return cell
    }

}
