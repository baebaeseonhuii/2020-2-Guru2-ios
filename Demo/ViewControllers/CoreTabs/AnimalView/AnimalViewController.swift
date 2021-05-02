//
//  AnimalViewController.swift
//  Demo
//
//  Created by apple on 2021/02/08.
//


import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class AnimalViewController: UIViewController {
    
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newBtn: UIButton!
    var databaseRef: DatabaseReference?
    
    var text_data = [DataInfo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference().child("my/animal")
        databaseRef?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else {return}
            if let species = value["species"] as? String, let feature = value["feature"] as? String, let location = value["location"] as? String, let image_url = value["image_url"] as? String {
                let url = URL(string: image_url)!
                let image_data = try? Data(contentsOf: url)
                let data = DataInfo(id: key, image: image_data!, species: species, feature: feature, location: location)
                self?.text_data.insert(data, at: 0)
                self?.tableView.beginUpdates()
                if let row = self?.text_data.count {
                    let indexPath = IndexPath(row: 0, section: 0)
                    self?.tableView.insertRows(at: [indexPath], with: .automatic)
                    self?.tableView.endUpdates()
                }
            }
        }
        newBtn.layer.cornerRadius = newBtn.layer.frame.size.width / 2   //+버튼 모서리 조절
    }
    
    //아이디 정보를 DetailController에 전달한다
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathsForSelectedRows?.first {
            let data_info = text_data[indexPath.row]
            if let vc = segue.destination as? AnimalDetailController {
                vc.data_id = data_info.id
            }
        }
    }
}

extension AnimalViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = text_data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "animalCell", for: indexPath) as! AnimalCell
        
        cell.animalImage?.image = UIImage(data: data.image)
        cell.speciesLabel?.text = "종: \(data.species)"
        cell.featureLabel?.text = "특징: \(data.feature)"
        cell.locationLabel?.text = "지역: \(data.location)"
        
        return cell
    }

}
