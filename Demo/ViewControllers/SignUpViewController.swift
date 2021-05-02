//
//  SignUpViewController.swift
//  Demo
//
//  Created by Kim Na Hee on 2021/02/10.
//

import UIKit
import FirebaseUI
import FirebaseAuth
import FirebaseDatabase
import Photos

class SignUpViewController: UIViewController {
    
    let ref = Storage.storage()
    var storageRef:StorageReference!
    var imagePicker:UIImagePickerController!
    var file_name:String!
    
    @IBOutlet weak var editImage: UIImageView!
    
    @IBAction func back(_ sender: Any) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    @IBOutlet weak var nicknameField: UITextField!
    @IBOutlet weak var phoneNumField: UITextField!
    
    @IBOutlet weak var errorLabel: UILabel!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var backToSignInButton: UIButton!
    
    @IBAction func signUpAction(_ sender: Any) {
//        if emailTextField.text?.isEmpty == true {
//            print("이메일을 입력해주세요")
//            return
//        }
//
//        if pwTextField.text?.isEmpty == true {
//            print("비밀번호를 입력해주세요")
//            return
//        }
        
        let error = validateFields()
        
        if error != nil {
            
            showError(error!)
        } else {
            
            signUp(email: emailTextField.text!, pw: pwTextField.text!)
        }
        
        //doSignUp()
    }

    @IBAction func alreadyHaveAnAccount(_ sender: Any) {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
        vc?.modalPresentationStyle = .overFullScreen
        present(vc!, animated: true)
    }
    
    @IBAction func imageOkBtn(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 취소버튼 추가
        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(action_cancel)
        
        // 갤러리 버튼 추가
        let action_gallery = UIAlertAction(title: "Gallery", style: .default) {
            (action) in
            print("push gallery button")
            // 갤러리에 접근할 권한이 있는지
            switch PHPhotoLibrary.authorizationStatus() {
            case .authorized:
                print("접근 가능")
                self.showGallery()
            case .notDetermined:
                print("권한 요청한 적 없음")
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
                }
            default:
                let alerVC = UIAlertController(title: "권한 필요", message: "사진첩 접근 권한이 필요합니다. 설정 화면에서 설정해주세요.", preferredStyle: .alert)
                let action_settings = UIAlertAction(title: "Go Settings", style: .default) { (action) in
                    print("go settings")
                    if let appSettings = URL(string:UIApplication.openSettingsURLString) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
                alerVC.addAction(action_settings)
                self.present(alerVC, animated: true, completion: nil)
            }
        }
        
        actionSheet.addAction(action_gallery)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    @IBAction func uploadImage(_ sender: Any) {
        print("upload btn pressed")
//        guard  let image = editImage.image else {
//            print("이미지 없음")
//            let alertVC = UIAlertController(title: "알림", message: "이미지를 선택하고 업로드 기능을 실행하세요.", preferredStyle: .alert)
//            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//            alertVC.addAction(okAction)
//            self.present(alertVC, animated: true, completion: nil)
//            return
//        }
//        print("이미지 있음")
//        if let data = image.pngData() {
//            let imageRef = storageRef.child("images/\(file_name).png")
//            let metadata = StorageMetadata()
//            metadata.contentType = "image/png"
//            let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in
//
//                if let error = error {
//                    debugPrint(error)
//                    return
//                }
//                guard let metadata = metadata else {
//                    return
//                }
//
//                imageRef.downloadURL { (url, error) in
//                    guard let downloadURL = url else {
//                        return
//                    }
//                    print(downloadURL, "upload complete")
//                }
//            }
//
//        }
        }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
    }
    
    func setUpElements() {
        
        errorLabel.alpha = 0
        
        Utilities.styleTextField(emailTextField)

        Utilities.styleTextField(pwTextField)
        
        Utilities.styleTextField(nicknameField)
        
        Utilities.styleTextField(phoneNumField)
        
        Utilities.styleHollowButton(signUpButton)
        
        Utilities.styleHollowButton(backToSignInButton)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
//                vc.modalPresentationStyle = .fullScreen
//                self.present(vc, animated: false, completion: nil)
//            }
        }
        
        
    }
    



extension SignUpViewController {
    func showAlert(message:String) {
        let alert = UIAlertController(title: "회원가입 실패", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: UIAlertAction.Style.default))
        self.present(alert, animated: true, completion: nil)
    }
    
    //func doSignUp(){
//        if emailTextField.text! == "" {
//            showAlert(message: "이메일을 입력해주세요")
//            return
//        }
//
//        if pwTextField.text! == "" {
//            showAlert(message: "비밀번호를 입력해주세요")
//            return
//        }
//
//        if nicknameField.text! == "" {
//            showAlert(message: "사용할 닉네임을 입력해주세요")
//            return
//        }
//
//        if phoneNumField.text! == "" {
//            showAlert(message: "전화번호를 입력해주세요")
//            return
//        }
        
        
//        signUp(email: emailTextField.text!, pw: pwTextField.text!)
        
    //}
    
    func validateFields() -> String? {
        
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            pwTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            nicknameField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            phoneNumField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
         
            return "회원정보를 모두 채워주세요."
        }
        
        let cleanedPW = pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if Utilities.isPasswordValid(cleanedPW) == false {
            return "비밀번호는 문자, 숫자, 특수문자를 포함하여 최소 8자리 이상 기입해주세요."
        }
        
        return nil
    }
    
    func showError(_ message: String) {
        
        errorLabel.text = message
        errorLabel.alpha = 1
    }
    
    func signUp(email:String, pw:String) {
        
        let nickname = nicknameField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = pwTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let phonenum = phoneNumField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().createUser(withEmail: email, password: pw) { (user, error) in
            
            if error != nil {
                self.showError("Error in creating user")
                if let ErrorCode = AuthErrorCode(rawValue: (error?._code)!) {
                    switch ErrorCode {
                    case AuthErrorCode.invalidEmail:
                        self.showAlert(message: "유효하지 않은 이메일입니다.")
                    case AuthErrorCode.emailAlreadyInUse:
                        self.showAlert(message: "이미 가입된 이메일입니다.")
                    case AuthErrorCode.weakPassword:
                        self.showAlert(message: "비밀번호는 최소 6자리 이상으로 생성해주세요.")
                    default:
                        print(ErrorCode)
                    }
                    
                    
                }
                
                
            } else {
                
                let db = Firestore.firestore()
                
                db.collection("user").addDocument(data: ["nickname": nickname, "email": email, "password": password, "uid": user!.user.uid , "phonenum": phonenum]) { (error) in
                    
                    if error != nil {
                        self.showError("Error in saving user data")
                        print("user data error")
                    }
                }
                
                print("회원가입 성공!")
                dump(user)
                
                let userdefault = UserDefaults.standard
                userdefault.setValue(true, forKey: "isFirst")
                
                //self.dismiss(animated: true, completion: nil)
                goHome()
            }
        }
        
//        let sb = UIStoryboard(name: "Main", bundle: nil)
//        let vc = storyboard?.instantiateViewController(withIdentifier: "SignInViewController")
//        vc?.modalPresentationStyle = .overFullScreen
//
//        view.window?.makeKeyAndVisible()
//
//        present(vc!, animated: true)
        
        func goHome() {
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "HomeViewController") {
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: false, completion: nil)
            }
        }
        
    }
    
}

extension SignUpViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker,animated: true, completion:  nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }
        
        if let url = info[.imageURL] as? URL {
            file_name = (url.lastPathComponent as NSString).deletingPathExtension
        }
        editImage.image = selectedImage
    }
}
