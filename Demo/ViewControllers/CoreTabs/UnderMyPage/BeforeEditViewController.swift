//
//  BeforeEditViewController.swift
//  Demo
//
//  Created by apple on 2021/02/10.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class BeforeEditViewController: UIViewController {
    @IBOutlet weak var idlabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: DatabaseReference?
    
    struct datasource {
        var id : String
        var idid : String
        var password : String
    }
    let testPass = "Nickname"
    
    var text_data = [datasource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("my/account")
        ref?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else {return}
            if let idid = value["id"] as? String, let password = value["password"] as? String {
                let data = datasource(id: key, idid: idid, password: password)
                self?.text_data.append(data)
                }
            }
        idlabel.text = "Nickname"
        
    }
    
    
    
    @IBAction func nextBtn(_ sender: Any) {
        if passwordTextField.text ==  testPass {
            
        } else {
            let alertVC = UIAlertController(title: "비밀번호 확인", message: "비밀번호가 일치하지 않습니다. 다시 확인해주세요.", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertVC.addAction(closeAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
}
