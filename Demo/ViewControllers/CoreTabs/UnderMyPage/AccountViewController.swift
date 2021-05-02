//
//  AccountViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class AccountViewController: UIViewController {
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var secondpasswordField: UITextField!
    @IBOutlet weak var phonenumTextFiled: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    var ref: DatabaseReference?
    
    struct datasource {
        var id : String
        var idid : String
        var password : String
        var phonenum : String
        var email : String
    }
    
    var text_data = [datasource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference().child("my/account")
        ref?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else {return}
            if let idid = value["id"] as? String, let password = value["password"] as? String, let phonenum = value["phonenum"] as? String, let email = value["email"] as? String {
                let data = datasource(id: key, idid: idid, password: password, phonenum: phonenum, email: email)
                self?.text_data.append(data)
                }
            }
        idLabel.text = "Nickname"
        passwordTextField.text = "새로운 비밀번호를 입력해주세요."
        passwordTextField.textColor = UIColor.lightGray
        secondpasswordField.text = "비밀번호를 한 번 더 입력해주세요."
        secondpasswordField.textColor = UIColor.lightGray
        phonenumTextFiled.text = "010-1234-5678"
        phonenumTextFiled.textColor = UIColor.lightGray
        emailTextField.text = "seon@gmail.com"
        emailTextField.textColor = UIColor.lightGray
        }
    
    
    @IBAction func okBtn(_ sender: Any) {
        if passwordTextField.text ==  secondpasswordField.text {
            self.text_data[0].password = passwordTextField.text!
            ref = Database.database().reference().child("my/account")
            ref?.childByAutoId().setValue(["password" : self.text_data[0].password])
            self.text_data[0].phonenum = phonenumTextFiled.text!
            ref?.childByAutoId().setValue(["phonenum" : self.text_data[0].phonenum])
            self.text_data[0].email = emailTextField.text!
            ref?.childByAutoId().setValue(["email" : self.text_data[0].email])
        } else {
            let alertVC = UIAlertController(title: "비밀번호 확인", message: "비밀번호가 일치하지 않습니다. 다시 확인해주세요.", preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alertVC.addAction(closeAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
        
}

