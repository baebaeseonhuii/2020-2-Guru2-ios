//
//  SearchViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/01/28.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseFirestore

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var regionTextField: UITextField!
    
    var data = ["시츄", "말티즈", "노견", "점박이", "대형견", "중형견","소형견","짖음","목줄","산책","애견", "apple"]
    
    
    
    let region = ["서울", "광주", "대구", "대전", "부산", "세종", "울산", "인천", "제주", "강원", "경기", "경상남도", "경상북도", "전라남도", "전라북도", "충청남도", "충청북도"]
    
    var picker = UIPickerView()
    
    var databaseRef: DatabaseReference?
    var mainData = [DataInfo]()
    
    
    // MARK: = ViewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "검색"
        
//        databaseRef = Database.database().reference().child("my/search")
//        databaseRef?.observe(.childAdded){ [weak self](snapshot) in
//            let key = snapshot.key
//            guard let value = snapshot.value as? [String : Any] else {return}
//            if let species = value["species"] as? String, let feature = value["feature"] as? String, let location = value["location"] as? String, let image_url = value["image_url"] as? String {
//                let url = URL(string: image_url)!
//                let image_data = try? Data(contentsOf: url)
//                let data = DataInfo(id: key, image: image_data!, species: species, feature: feature, location: location)
//                self?.mainData.insert(data, at: 0)
//                self?.table.beginUpdates()
//                if let row = self?.mainData.count {
//                    let indexPath = IndexPath(row: 0, section: 0)
//                    self?.table.insertRows(at: [indexPath], with: .automatic)
//                    self?.table.endUpdates()
//                }
//            }
//        }
        
        
        self.searchBar.delegate = self
        table.delegate = self
        table.dataSource = self
        regionTextField.delegate = self
        searchBar.delegate = self
        
        picker.dataSource = self
        picker.delegate = self
        
        regionTextField.inputView = picker
        
        doneButton()
    }

        
    

    var searchKeyword = [String]()
    var searching = false
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = self.table.indexPathsForSelectedRows?.first {
//            let data_info = mainData[indexPath.row]
//            if let vc = segue.destination as? InsideSearchViewController {
//                //vc.data_id = data_info.id
//            }
//        }
//    }
//    
    
    // MARK: = Buttons
    
    @IBAction func keywordButton() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InsideSearchViewController") as! InsideSearchViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func doneButton() {
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        regionTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func donePressed() {
        self.view.endEditing(true)
    }
    
}


// MARK: = PickerView
extension SearchViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return region.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        regionTextField.text = region[row]
    }
    
}

extension SearchViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return region[row]
    }
    
}


// MARK: = TableView Delegate, Datasource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching {
            return searchKeyword.count
        } else {
            return data.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "wordCell", for: indexPath)
        if searching {
            cell.textLabel?.text = data[indexPath.row]
        } else {
            cell.textLabel?.text = data[indexPath.row]
        }
        
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InsideSearchViewController") as! InsideSearchViewController
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

// MARK: = Search Bar Delegate

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchKeyword = data.filter({$0.prefix(searchText.count) == searchText})
        searching = true
        table.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        table.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InsideSearchViewController") as! InsideSearchViewController
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
