//
//  BoardViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/01/21.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class BoardViewController: UIViewController {
    var ref: DatabaseReference!
    var refHandle:DatabaseHandle!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var newBtn: UIButton!
    var databaseRef: DatabaseReference?
    
    var text_data = [FreeInfo]()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "소통게시판"
        // Do any additional setup after loading the view.
        databaseRef = Database.database().reference().child("my/freeboard")
        databaseRef?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else {return}
            if let title = value["title"] as? String, let content = value["content"] as? String {
                let data = FreeInfo(id: key, title: title, content: content)
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
    //    아이디 정보를 DetailController에 전달한다
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathsForSelectedRows?.first {
            let data_info = text_data[indexPath.row]
            if let vc = segue.destination as? BoardDetailViewController {
                vc.data_id = data_info.id
            }
        }
    }
}

extension BoardViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = text_data[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "freeboardCell", for: indexPath) as! BoardCell
        
        cell.boardLabel?.text = data.title
        cell.contentLabel?.text = data.content
        //self.titleLabel?.text = data.title
        
        return cell
    }
    
    
}
 
