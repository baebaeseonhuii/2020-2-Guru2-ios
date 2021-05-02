//
//  SignInViewController.swift
//  Demo
//
//  Created by Kim Na Hee on 2021/02/10.
//

import UIKit
import AVKit
import FirebaseAuth

class SignInViewController: UIViewController {
    
    var videoPlayer:AVPlayer?
    
    var videoPlayerLayer:AVPlayerLayer?
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBAction func loginTapped(_ sender: Any) {
        
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {[weak self] (result, err) in
            guard let strongSelf = self else {return}
            if let err = err {
                print(err.localizedDescription)
                self!.errorLabel.text = err.localizedDescription
                self!.errorLabel.alpha = 1
                return
            }
            let userdefault = UserDefaults.standard
            userdefault.setValue(true, forKey: "isFirst")
            self!.goHome()
        }

    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SignUpViewController")
        vc.modalPresentationStyle = .overFullScreen
        present(vc, animated: true)
    }
    
    
    
    func validateFields() {
        if emailTextField.text?.isEmpty == true {
            print("이메일을 입력해주세요")
            return
        }
        
        if passwordTextField.text?.isEmpty == true {
            print("비밀번호를 입력해주세요")
            return
        }
    }
    
  
  
    
    override func viewDidLoad() {
        transparentNavigationBar()
        
        super.viewDidLoad()
        setUpVideo()
            //assignbackground()
        
        setUpElements()
    }
    
    func assignbackground() {
        let background = UIImage(named: "guruintro_login.png")
        
        var imageView : UIImageView!
        imageView = UIImageView(frame: view.bounds)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = background
        imageView.center = view.center
        view.addSubview(imageView)
        self.view.sendSubviewToBack(imageView)
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        setUpVideo()
//    }
    
    func setUpVideo() {
        
        let bundlePath = Bundle.main.path(forResource: "슈냥이", ofType: "mp4")
        
        guard bundlePath != nil else {
            return
        }
        
        let url = URL(fileURLWithPath: bundlePath!)
        
        let item = AVPlayerItem(url: url)
    
        videoPlayer = AVPlayer(playerItem: item)
        
        videoPlayerLayer = AVPlayerLayer(player: videoPlayer!)
        
        videoPlayerLayer?.frame = CGRect(x: -self.view.frame.size.width*1.5, y: 0, width: self.view.frame.size.width*4, height: self.view.frame.size.height)
        
        view.layer.insertSublayer(videoPlayerLayer!, at: 0)
        
        videoPlayer?.playImmediately(atRate: 0.5)
        videoPlayer?.volume = 0
        
    }
    
    
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signInButton)
        Utilities.styleFilledButton(signUpButton)
    }
    
    func goHome() {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if let user = Auth.auth().currentUser {
            goHome()
        }
    }
    
    
}


extension SignInViewController {
    func transparentNavigationBar() {
        guard let navi = self.navigationController?.navigationBar else { return}
        navi.setBackgroundImage(UIImage(), for: .default)
        navi.shadowImage = UIImage()
        navi.isTranslucent = true
    }
}
