//
//  NewFreeViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Photos
import AVKit

class NewFreeViewController: UIViewController, UITextViewDelegate {
    var storageRef: StorageReference!
    var databaseRef: DatabaseReference?
    let storage = Storage.storage()
    var imagePicker:UIImagePickerController!
    var file_name: String!
    var downloadURL:Any!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        storageRef = storage.reference()
        
        placeholderSetting()    //textView 텍스트홀더 선언
    }
    
    @IBAction func photoBtn(_ sender: Any) {
        switch PHPhotoLibrary.authorizationStatus() { //갤러리에 접근할 권한이 있는지 확인
        case .authorized:
            print("접근 가능")
            self.showGallery()
        case .notDetermined:
            print("권한 요청한적 없음")
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { (status) in
            }
        default:
            let alertVC = UIAlertController(title: "권한 필요", message: "사진첩 접근 권한이 필요합니다. 설정 화면에서 설정해주세요.", preferredStyle: .alert)
            let action_settings = UIAlertAction(title: "Go Settings", style: .default) { (action) in
                print("go settings")
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
            let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alertVC.addAction(action_settings)
            alertVC.addAction(action_cancel)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    //textView에 텍스트홀더 작성하기
    func placeholderSetting() {
        contentTextView.delegate = self
        contentTextView.text = "내용을 적어주세요."
        contentTextView.textColor = UIColor.lightGray
   
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.textColor == UIColor.lightGray {
            contentTextView.text = nil
            contentTextView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.isEmpty {
            contentTextView.text = "내용을 적어주세요."
            contentTextView.textColor = UIColor.lightGray
        }
    }
    @IBAction func finishBtn(_ sender: Any) {
        databaseRef = Database.database().reference().child("my/freeboard").childByAutoId()
        
        
        guard let image = imageView.image else {
            let alertVC = UIAlertController(title: "알림", message: "이미지를 선택하고 업로드 기능을 실행하세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        if let data = image.pngData() {
            let imageRef = storageRef.child("freeboard/\(file_name!).png")
            let metadata = StorageMetadata()
            metadata.contentType = "image/png"
            let uploadTask = imageRef.putData(data, metadata: metadata) { (metadata, error) in
                guard let metadata = metadata else {
                    return
                }
                imageRef.downloadURL{(url, error) in
                    guard let downloadURL = url else {
                        return
                    }
                    guard let key = self.databaseRef?.key else { return }
                    self.databaseRef?.setValue(["title": "\(self.titleTextField.text!)",
                                                "content": "\(self.contentTextView.text!)", "image_url": downloadURL.absoluteString])
                    print(downloadURL, "upload complete")
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewFreeViewController:UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //갤러리 띄우기
    func showGallery() {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //사진 선택해서 이미지뷰에 넣기
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[.originalImage] as? UIImage else {
            return
        }

        if let url = info[.imageURL] as? URL {
            file_name = (url.lastPathComponent as NSString).deletingPathExtension   //확장자 떼기
        }
        
        imageView.image = selectedImage
        
    }
}
