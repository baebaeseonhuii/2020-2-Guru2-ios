//
//  VolunteerViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/01/28.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class VolunteerViewController: UIViewController {
    
    
    var ref: DatabaseReference!
    var refHandle:DatabaseHandle!
    var imageUrls:String!
    
    var databaseRef: DatabaseReference?
    var text_data = [VTRInfo]()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var NewBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "봉사"
        
        databaseRef = Database.database().reference().child("my/volunteer/board")
        databaseRef?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else {return}
            if let location = value["location"] as? String, let houseName = value["houseName"] as? String, let date = value["date"] as? String, let peopleNum = value["peopleNum"] as? String, let image_url = value["image_url"] as? String {
                let url = URL(string: image_url)!
                let image_data = try? Data(contentsOf: url)
                let data = VTRInfo(id: key, image: image_data!, location: location, houseName: houseName, date: date, peopleNum: peopleNum)
                self?.text_data.insert(data, at: 0)
                self?.tableView.beginUpdates()
                if let row = self?.text_data.count {
                    let indexPath = IndexPath(row: row-1, section: 0)
                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
                    self?.tableView.endUpdates()
                }
            }
        }
        
        NewBtn.layer.cornerRadius = NewBtn.layer.frame.size.width / 2
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathsForSelectedRows?.first {
            let data_info = text_data[indexPath.row]
            if let vc = segue.destination as? VolunteerDetailViewController {
                vc.data_id = data_info.id
                print(data_info.id)
            }
        }
    }
   
}
extension VolunteerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = text_data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "VTRcell", for: indexPath) as! VolunteerTableViewCell
        cell.locationLabel?.text = data.houseName
        cell.img?.image = UIImage(data: data.image)
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = storyboard?.instantiateViewController(identifier: "VolunteerDetailViewController") as! VolunteerDetailViewController
//        vc.image = UIImage(named: "dog")!
//        vc.name = name[indexPath.row]
//        self.navigationController?.pushViewController(vc, animated: true)
//    }
    
}
