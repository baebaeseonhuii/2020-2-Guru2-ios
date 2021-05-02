//
//  MyWritingViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class MyWritingViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var animalRef: DatabaseReference?
    var masterRef: DatabaseReference?
    var freeRef: DatabaseReference?
    var volRef: DatabaseReference?
    
    struct datasource {
        var id : String
        var image: Data
        var title : String
    }
    
    var text_data = [DataInfo]()
    var board_text_data = [FreeInfo]()
    var vtr_text_data = [VTRInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animalRef = Database.database().reference().child("my/animal")
        animalRef?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else {return}
            if let species = value["species"] as? String, let feature = value["feature"] as? String, let location = value["location"] as? String, let image_url = value["image_url"] as? String {
                let url = URL(string: image_url)!
                let image_data = try? Data(contentsOf: url)
                let data = DataInfo(id: key, image: image_data!, species: species, feature: feature, location: location)
                self?.text_data.append(data)
                if let row = self?.text_data.count {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
                    self?.tableView.endUpdates()
                }
            }
        }
//        masterRef = Database.database().reference().child("my/master")
//        masterRef?.observe(.childAdded){ [weak self](snapshot) in
//            let key = snapshot.key
//            guard let value = snapshot.value as? [String : Any] else {return}
//            if let species = value["species"] as? String, let feature = value["feature"] as? String, let location = value["location"] as? String, let image_url = value["image_url"] as? String {
//                let url = URL(string: image_url)!
//                let image_data = try? Data(contentsOf: url)
//                let data = DataInfo(id: key, image: image_data!, species: species, feature: feature, location: location)
//                self?.text_data.append(data)
//                if let row = self?.text_data.count {
//                    let indexPath = IndexPath(row: 0, section: 0)
//                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
//                    self?.tableView.endUpdates()
//                }
//            }
//        }
//        freeRef = Database.database().reference().child("my/freeboard")
//        freeRef?.observe(.childAdded){ [weak self](snapshot) in
//            let key = snapshot.key
//            guard let value = snapshot.value as? [String : Any] else {return}
//            if let title = value["title"] as? String, let content = value["content"] as? String {
//                let data = FreeInfo(id: key, title: title, content: content)
//                self?.board_text_data.append(data)
//                self?.tableView.beginUpdates()
//                if let row = self?.board_text_data.count {
//                    let indexPath = IndexPath(row: 0, section: 0)
//                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
//                    self?.tableView.endUpdates()
//                }
//            }
//        }
//        volRef = Database.database().reference().child("my/volunteer")
//        volRef?.observe(.childAdded){ [weak self](snapshot) in
//            let key = snapshot.key
//            guard let value = snapshot.value as? [String : Any] else {return}
//            if let location = value["location"] as? String, let houseName = value["houseName"] as? String, let date = value["date"] as? String, let peopleNum = value["peopleNum"] as? String, let image_url = value["image_url"] as? String {
//                let url = URL(string: image_url)!
//                let image_data = try? Data(contentsOf: url)
//                let data = VTRInfo(id: key, image: image_data!, location: location, houseName: houseName, date: date, peopleNum: peopleNum)
//                self?.vtr_text_data.append(data)
//                if let row = self?.vtr_text_data.count {
//                    let indexPath = IndexPath(row: 0, section: 0)
//                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
//                    self?.tableView.endUpdates()
//                }
//            }
//        }
    }
    
    //아이디 정보를 DetailController에 전달한다
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathsForSelectedRows?.first {
            let data_info = text_data[indexPath.row]
            if let vc = segue.destination as? AnimalDetailController {
                vc.data_id = data_info.id
            }
//            if let vc = segue.destination as? MasterDetailController {
//                vc.data_id = data_info.id
//            }
//            if let vc = segue.destination as? VolunteerDetailViewController {
//                //vc.data_id = data_info.id
//            }
//            if let vc = segue.destination as? BoardDetailViewController {
//                vc.data_id = data_info.id
//            }
        }
    }
}

extension MyWritingViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return text_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = text_data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyWritingCell", for: indexPath) as! MyWritingCell
        
        cell.MyWritingImg?.image = UIImage(data: data.image)
        cell.titleLabel?.text = "data.title"
        
        return cell
    }

}

