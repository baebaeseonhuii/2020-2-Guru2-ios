//
//  ChatListViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/02/04.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ChatListViewController: UIViewController {
    var chat_room_list = [QueryDocumentSnapshot]()
    let db = Firestore.firestore()
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var chatBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "채팅"
        
        chatBtn.layer.cornerRadius = 20
    
        db.collection("chattings").getDocuments { (snapshot, error) in
            if let error = error{
                print(error)
                return
            }
            self.chat_room_list = [QueryDocumentSnapshot]()
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    self.chat_room_list.append(document)
                }
                self.tableView?.reloadData()
            }
        }
        
        db.collection("chattings").addSnapshotListener { (snapshot, error) in
            if let error = error {
                print(error)
                return
            }
            if let snapshot = snapshot {
                for change in snapshot.documentChanges {
                    print(change.document.data())
                    let docID = change.document.documentID
                    let document = change.document
                    if self.isNews(document) {
                        self.chat_room_list.append(document)
                        self.tableView?.insertRows(at: [IndexPath(row: self.chat_room_list.count-1, section: 0)], with: .left)
                    }
                }
            }
        }
    }
    
    func isNews(_ doc: QueryDocumentSnapshot) -> Bool {
        
        var result = true
        for chat_room in chat_room_list {
            if chat_room.documentID == doc.documentID {
                return false
            }
        }
        return true
    }
    
    
    @IBAction func makeChatRoom(_ sender: UIBarButtonItem) {
        let alertVC = UIAlertController(title: "New Chat", message: "Enter your chat room name", preferredStyle: .alert)
        alertVC.addTextField { (textfield) in
            textfield.placeholder = "room name"
        }
        
        let action_cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertVC.addAction(action_cancel)
        
        let action_ok = UIAlertAction(title: "OK", style: .default) { (action) in
            if let textFields = alertVC.textFields, let textField = textFields.first {
                print(textField.text)
                self.addChatRoom(textField.text!)
                
            }
        }
        alertVC.addAction(action_ok)
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func addChatRoom(_ room_name: String) {
        var ref: DocumentReference? = nil
        ref = db.collection("chattings").document()
        ref?.setData(["name": room_name,
                        "members": []]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
               
            }
        }
    }
}
extension ChatListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.chat_room_list.count
        
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatRoomCell") as! UITableViewCell
        let document = chat_room_list[indexPath.row]
        let data = document.data()
        cell.textLabel?.text = data["name"] as! String
       
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let btnDelete = UIContextualAction(style: .destructive, title: "삭제") { [weak self](action, view, completion) in
            let row = indexPath.row
            self!.chat_room_list.remove(at: row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
            completion(true)
        }
        return UISwipeActionsConfiguration(actions: [btnDelete])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        print(chat_room_list[indexPath.row].documentID)
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "chatRoomVC") as? InsideChatViewController {
            print("enter room")
            vc.modalPresentationStyle = .fullScreen
            vc.chat_room_id = chat_room_list[indexPath.row].documentID
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        
        
    }

}
