//
//  EditProfileViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore
import Photos

class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var editImage: UIImageView!
    @IBOutlet weak var editTextField: UITextField!
    
    var ref: DatabaseReference?
    var imagePicker:UIImagePickerController!
    var storageRef:StorageReference!
    var file_name:String!
    
    struct datasource {
        var id : String
        var profileImage: Data
        var nickname : String
    }

    var text_data = [datasource]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference().child("my/profile")
        ref?.observe(.childAdded){ [weak self](snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else {return}
            if let nickname = value["nickname"] as? String, let image_url = value["image_url"] as? String {
                let url = URL(string: image_url)!
                let image_data = try? Data(contentsOf: url)
                let data = datasource(id: key, profileImage: image_data!, nickname: nickname)
                self?.text_data.append(data)
                }
            }
        editImage.image?.imageData = text_data[0].profileImage
        editTextField.text = "Nickname"
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
        guard  let image = editImage.image else {
            print("이미지 없음")
            let alertVC = UIAlertController(title: "알림", message: "이미지를 선택하고 업로드 기능을 실행하세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        print("이미지 있음")
        if let data = image.pngData() {
            debugPrint(data)
            let imageRef = storageRef.child("my/profile/image_url\(file_name!).png")
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                imageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    guard let key = self.ref!.child("my/profile/image_url").childByAutoId().key
                        else { return }
                    self.ref!.child("my/profile/image_url/\(key)").setValue(["image_url":downloadURL.absoluteString])
                    print(downloadURL, "upload complete")
                    let url = URL(string: downloadURL.absoluteString)!
                    let image_data = try? Data(contentsOf: url)
                    self.text_data[0].profileImage = image_data!
                }
            }
        }
    }
    
    @IBAction func okBtn(_ sender: Any) {
        var data = editTextField.text
        self.text_data[0].nickname = data!
    }
}

extension EditProfileViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
