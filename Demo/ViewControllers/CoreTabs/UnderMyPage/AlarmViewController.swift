//
//  AlarmViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import FirebaseDatabase
import UserNotifications

class AlarmViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var inputTextField: UITextField!

    struct datasource {
        var id : String
        var data : String
    }
    
    var text_data = [datasource]()
    
    //파일의 위치
    var databasePath = String()
    var ref: DatabaseReference!
    var refHandle : DatabaseHandle!
    
    override func viewDidLoad() {
        // 뷰 인스턴스가 메모리에 올라왔고, 아직 화면은 뜨지 않은 상황
        super.viewDidLoad()
        ref = Database.database().reference().child("my/keywords")
            ref?.observe(.childAdded){ [weak self](snapshot) in
                let key = snapshot.key
                    guard let value = snapshot.value as? [String : Any] else {return}
                    if let keyword = value["keyword"] as? String {
                        let data = datasource(id: key, data: keyword)
                        self?.text_data.append(data)
                        if let row = self?.text_data.count {
                            let indexPath = IndexPath(row: row-1, section: 0)
                            self?.tableView.insertRows(at: [indexPath], with: .automatic)
                        }
                    }
                }
        
    }
    
    @objc func fetchData(_ sender:Any) {
        tableView.refreshControl?.endRefreshing() //있으면 꺼라
    }
    
    //나타나기 직전
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 네비게이션 바 숨기기
        self.navigationController?.setNavigationBarHidden(false, animated: false)

    }
    
    
    @IBAction func addMemo(_ sender: UIButton) {
    //옵셔널 벗겨주기
    guard let memo = inputTextField.text, memo != "" else { //빈칸은 안되게
        return
    }
    // 추가한 후 텍스트필드 초기화
    inputTextField.text = ""
    self.tableView.reloadData()
    ref = Database.database().reference().child("my/keywords")
    ref?.childByAutoId().setValue(["keyword" : memo])
    
    }
    
    func removeData(key : String) {
        let memoRef = ref.child(key)
        memoRef.removeValue()
    }
}

extension AlarmViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return text_data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as! AlarmCell
        let data = text_data[indexPath.row]
        cell.keywordLabel.text = data.data
        return cell
    }
    
}


extension AlarmViewController:UITableViewDelegate {

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return.none
    }
    
    // 앞에 들여쓰기 되지 않게 하기
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    //스와이프를 했을 때 셀 오른쪽 끝에 나타날 버튼 지정
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let btnEdit = UIContextualAction(style: .normal, title: "Edit") { (action, view, completion) in
            // 데이터 수정하기
            let editAlert = UIAlertController(title: "Edit Memo", message: "change your memo", preferredStyle: .alert)
            
            editAlert.addTextField { (textField) in
                let data = self.text_data[indexPath.row]
                textField.text = data.data
                //placehold 사용하면 모두 없어지기
            }
            
            editAlert.addAction(UIAlertAction(title: "Modify", style: .default, handler: { (action) in
                if let fields = editAlert.textFields, let textField = fields.first, let getText = textField.text {
                    self.text_data[indexPath.row].data = getText
                    // 전체 로드
                    //self.tableView.reloadData()
                    // 한 줄 한 줄 로드
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                    //있는 데이터 수정할 때
                    self.ref.child(self.text_data[indexPath.row].id).updateChildValues(["keyword":getText])
                }
            }))
            
            editAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            // 화면에 띄우기
            self.present(editAlert, animated: true, completion: nil)
            completion(true)
        }
        
        let btnDelete = UIContextualAction(style: .destructive, title: "Del") { (action, view, completion) in
            //데이터에서 지우기
            self.removeData(key: self.text_data[indexPath.row].id)
            self.text_data.remove(at: indexPath.row)
            //화면에서 지우기
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            completion(true)
        }
        btnEdit.backgroundColor = .blue
        btnDelete.backgroundColor = .black //UIColor.black에서 생략 (타입에 맞춰)
        
        return UISwipeActionsConfiguration(actions: [btnDelete, btnEdit])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView.frame.height / 12
    }

}



