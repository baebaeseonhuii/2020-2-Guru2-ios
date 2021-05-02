//
//  OutViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import FirebaseAuth
import FirebaseUI

class OutViewController: UIViewController {
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // 탈퇴 버튼 클릭 시
    @IBAction func outBtn(_ sender: Any) {
        let alertVC = UIAlertController(title: "탈퇴", message: "정말 탈퇴하시겠습니까?", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        let outAction = UIAlertAction(title: "탈퇴", style: .default) {
            (action) in
                    let user = Auth.auth().currentUser
                    user?.delete { error in
                      if let error = error {
                       print(error)
                      } else {
                        // Account deleted.
                      }
                    }
                    self.dismiss(animated: true, completion: nil)
            
            }
        alertVC.addAction(closeAction)
        alertVC.addAction(outAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
