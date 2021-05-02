//
//  ViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/01/21.
//

import UIKit
import FirebaseStorage
import FirebaseUI

class HomeViewController: UIViewController, FUIAuthDelegate {
    
    let authUI = FUIAuth.defaultAuthUI()
    var handle:AuthStateDidChangeListenerHandle!
    
    static var isFirst = true
    var selectedIndex:Int = 0
    var previousIndex:Int = 0

    
    @IBOutlet weak var searchBtns: UIButton!
    @IBOutlet var tabBtns: [UIStackView]!
    
    var viewControllers = [UIViewController]()
    
    @IBOutlet weak var tabStackView: UIStackView!
    
    
    static let MasterViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MasterViewController")
    static let AnimalViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AnimalViewController")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "홈"
        for btn in tabBtns {
            let tap = UITapGestureRecognizer(target: self, action: #selector(tabTapped(_:)))
            btn.isUserInteractionEnabled = true
            btn.addGestureRecognizer(tap)
        }
        viewControllers.append(HomeViewController.MasterViewController)
        viewControllers.append(HomeViewController.AnimalViewController)
        
        tabTapped(tabBtns[0].gestureRecognizers![0] as! UITapGestureRecognizer)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userdefault = UserDefaults.standard
        if userdefault.bool(forKey: "isFirst") {
            print("first!!")
            if let currentUser = Auth.auth().currentUser {
                // 로그인 상태
                let alertController = UIAlertController(title: "로그인", message: "\(currentUser.email!)! 어서오시개!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "시작", style: .default, handler: nil))
                self.present(alertController, animated: false, completion: nil)
            }
            userdefault.setValue(false, forKey: "isFirst")
        }
    }
    
//    let authUI = FUIAuth.defaultAuthUI()
//    var handle:AuthStateDidChangeListenerHandle!
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
//            if let currentUser = auth.currentUser {
//                // 로그인 상태
//                let alertController = UIAlertController(title: "로그인", message: "\(currentUser.displayName!)! 어서오시개!", preferredStyle: .alert)
//                alertController.addAction(UIAlertAction(title: "시작", style: .default, handler: nil))
//                self.present(alertController, animated: false, completion: nil)
//            } else {
//                // 로그아웃 상태
//                self.authUI!.delegate = self
//                let providers: [FUIAuthProvider] = [
//                    FUIEmailAuth(),
//                    FUIGoogleAuth(),
//                    FUIFacebookAuth(),
//                    //FUIOAuth.appleAuthProvider()
//                ]
//                self.authUI!.providers = providers
//
//                let authViewController = self.authUI!.authViewController()
//                authViewController.modalPresentationStyle = .fullScreen
//
//                self.present(authViewController, animated: true, completion: nil)
//            }
//        }
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        Auth.auth().removeStateDidChangeListener(handle!)
//    }
//
//
//
//    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
//        print("로그인")
//        print(authDataResult)
//    }
    
    @objc func tabTapped(_ sender:UITapGestureRecognizer) {
        if let tag = sender.view?.tag { //tab을 했을 때 뷰 전환
            previousIndex = selectedIndex
            selectedIndex = tag

            //화면 갈아끼우기
            let previousVC = viewControllers[previousIndex]
            previousVC.willMove(toParent: nil)  //이전화면을 부모에게 보냄
            previousVC.view.removeFromSuperview()
            previousVC.removeFromParent()

            let currentVC = viewControllers[selectedIndex]
            currentVC.view.frame = UIApplication.shared.windows[0].frame
            currentVC.didMove(toParent: self)
            self.addChild(currentVC)
            self.view.addSubview(currentVC.view)
            self.view.bringSubviewToFront(searchBtns) //스택뷰를 항상 앞으로 가져오는 작업
            self.view.bringSubviewToFront(tabStackView) //스택뷰를 항상 앞으로 가져오는 작업
            
        }
    }
}

