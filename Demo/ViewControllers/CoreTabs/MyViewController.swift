//
//  MyViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/01/21.
//

import UIKit
import FirebaseAuth
import FirebaseUI
import UserNotifications

class MyViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }
    
    //첫번째 화면에서 네비게이션바 숨기기
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    //두번째 화면부터 네비게이션바 생기기
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // 공유하기 기능
    @IBAction func shareBtn(_ sender: Any) {
            let url = URL(string:"https://yeonhaneoul.com")
            let shareUrl:[Any] = [url!]
    
            let activityVC = UIActivityViewController(activityItems: shareUrl, applicationActivities: nil)
            activityVC.popoverPresentationController?.sourceView = self.view
            
            self.present(activityVC, animated: true, completion: nil)
        }
    
    // 버전 버튼 클릭 시
    @IBAction func versionBtn(_ sender: Any) {
        let alertVC = UIAlertController(title: "버전 정보", message: "현재 최신버전을 사용중입니다.", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "닫기", style: .default, handler: nil)
        alertVC.addAction(closeAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    
    // 로그아웃 버튼 클릭 시
    @IBAction func logoutBtn(_ sender: Any) {
        /*do {
                    try Auth.auth().signOut()
                  } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                  }*/
        
        let alertVC = UIAlertController(title: "로그아웃", message: "정말 로그아웃하시겠습니까?", preferredStyle: .alert)
        let closeAction = UIAlertAction(title: "닫기", style: .cancel, handler: nil)
        let logoutAction = UIAlertAction(title: "로그아웃", style: .default) {
            (action) in
            do {
                try Auth.auth().signOut()
                print("sign out")
                let userdefault = UserDefaults.standard
                userdefault.setValue(true, forKey: "isFirst")
                } catch let signOutError as NSError {
                    print ("Error signing out: %@", signOutError)
                }
            self.dismiss(animated: true, completion: nil)
        }
        alertVC.addAction(closeAction)
        alertVC.addAction(logoutAction)
        self.present(alertVC, animated: true, completion: nil)
        
        print("sign out complete")
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVC") {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
}
extension MyViewController:UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell", for : indexPath) as! myPageCell
        return cell
    }
    
}

