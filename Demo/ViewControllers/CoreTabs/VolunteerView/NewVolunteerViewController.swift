//
//  NewVolunteerViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/02/11.
//

import UIKit
import Firebase
import FirebaseFirestore
import FirebaseStorage
import Photos
import AVKit

class NewVolunteerViewController: UIViewController, UITextViewDelegate {
    
    var storageRef:StorageReference!
    var databaseRef: DatabaseReference?
    
    let storage = Storage.storage()
    var imagePicker:UIImagePickerController!
    var file_name:String!
    var selectTap = ""
    var selectLocation = ""
    var downloadURL:Any!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var houseNameTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var peopleNumTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    let location = ["서울특별시", "부산광역시", "대구광역시", "인천광역시", "광주광역시", "대전광역시", "울산광역시", "세종특별자치시", "경기도", "강원도", "충청북도", "충청남도", "전라북도", "전라남도", "경상북도", "경상남도", "제주특별자치도"]
    
    var pickerView = UIPickerView()
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        storageRef = storage.reference()
        
        placeholderSetting()    //textView 텍스트홀더 선언
        
        pickerView.delegate = self
        pickerView.dataSource = self

        locationTextField.inputView = pickerView
        locationTextField.textAlignment = .left
        
        createDatePicker()
        doneButton()
        
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
    
    func createDatePicker() {
        dateTextField.textAlignment = .left
        datePicker.preferredDatePickerStyle = .wheels
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(dateDonePressed))
        toolbar.setItems([doneBtn], animated: true)
    
        dateTextField.inputAccessoryView = toolbar
        dateTextField.inputView = datePicker
        datePicker.datePickerMode = .dateAndTime
        
    }
    
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
    
    func doneButton() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        locationTextField.inputAccessoryView = toolbar
    }
    
    @objc func donePressed() {
        locationTextField.text = selectLocation
        locationTextField.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    @objc func dateDonePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        dateTextField.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    @IBAction func finishBtn(_ sender: Any) {
        databaseRef = Database.database().reference().child("my/volunteer/board").childByAutoId()
        guard let image = imageView.image else {
            let alertVC = UIAlertController(title: "알림", message: "이미지를 선택하고 업로드 기능을 실행하세요.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
            return
        }
        if let data = image.pngData() {
            let imageRef = storageRef.child("volunteer/\(file_name!).png")
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
                    self.databaseRef?.setValue(["location": "\(self.locationTextField.text!)",
                                                "houseName": "\(self.houseNameTextField.text!)",
                                                "date": "\(self.dateTextField.text!)",
                                                "peopleNum": "\(self.peopleNumTextField.text!)",
                                                "content": "\(self.contentTextView.text!)",
                                                "image_url": downloadURL.absoluteString])
                    print(downloadURL, "upload complete")
                }
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension NewVolunteerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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

extension NewVolunteerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return location.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return location[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectLocation = location[row]
    }
}
