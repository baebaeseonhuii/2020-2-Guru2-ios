//
//  InsideChatViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/01/31.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import FirebaseAuth
import FirebaseFirestore

class InsideChatViewController: MessagesViewController {
    var chat_room_id: String!
    var currentUser: User!
    let db = Firestore.firestore()
    private let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = Auth.auth().currentUser
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        title = db.collection("chattings").document(chat_room_id!).collection("chat").document().documentID
        
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            let messageInsets = layout.textMessageSizeCalculator.outgoingMessageLabelInsets
                
            layout.setMessageOutgoingAvatarSize(.zero)
            layout.setMessageIncomingAvatarSize(.zero)
            
            // 'Read' string alignment
            layout.setMessageOutgoingCellBottomLabelAlignment(.init(textAlignment: .right, textInsets: messageInsets))
            
            // send data alignment
            layout.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: messageInsets))
            
            layout.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: messageInsets))
        }
        getMessages()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(self.chat_room_id!, "is room id.")
        
        db.collection("chattings").document(chat_room_id!).collection("chat").order(by: "date").addSnapshotListener { (snapshot, error) in
            if let error = error {
                return
            }
            if let snapshot = snapshot {
                snapshot.documentChanges.forEach { change in
                    if (change.type == .added) {
                        let document = change.document
                        let data = change.document.data()
                        let message = MockMessage(text: data["msg"] as! String, user: Sender(senderId: data["uid"] as! String, displayName: data["displayname"] as! String), messageId: document.documentID, date: (data["date"] as! Timestamp).dateValue())
                        self.insertMessage(message)
                    }
                    
                }
            }
        }
    }
    
    func getMessages() {
        // chattings/chatting room number/chat/chat list
        db.collection("chattings").document(chat_room_id!).collection("chat").order(by: "date").getDocuments { (snapshot, error) in
            if let error = error {
                return
            }
            if let snapshot = snapshot {
                for document in snapshot.documents {
                    print(document.documentID)
                    let data = document.data()
                    let message = MockMessage(text: data["msg"] as! String, user: Sender(senderId: data["uid"] as! String, displayName: data["displayname"] as! String), messageId: document.documentID, date: (data["date"] as! Timestamp).dateValue())
                    messages.append(message)
                }
                self.messagesCollectionView.reloadData()
            }
        }
    }
}

public struct Sender: SenderType, Equatable {
    public let senderId: String

    public let displayName: String
}



// Some global variables for the sake of the example. Using globals is not recommended!
var messages: [MockMessage] = []

extension InsideChatViewController: MessagesDataSource {

    func currentSender() -> SenderType {
        return Sender(senderId: currentUser.uid, displayName: currentUser.displayName ?? "")
    }

    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }

    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }

    func cellBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        return NSAttributedString(string: "Read", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
    }

    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }

    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}


extension InsideChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        processInputBar(messageInputBar)
    }
    
    private func insertMessages(_ data: [Any]) {
        for component in data {
            let user = self.currentSender()
            if let str = component as? String {
                let ref = db.collection("chattings").document(chat_room_id!).collection("chat").document()
                let current_date = Date()
                let messageId = ref.documentID
                
                //데이터 베이스에 데이터 넣기
                ref.setData([
                    "uid": user.senderId,
                    "displayname": user.displayName,
                    "msg": str,
                    "date": current_date
                
                ]) { err in
                    if let err = err {
                        print("Error writing document: \(err)")
                    } else {
                        print("Document successfully written!")
                        
                    }
                }
            } else if let img = component as? UIImage {
                let message = MockMessage(image: img, user: user, messageId: UUID().uuidString, date: Date())
                insertMessage(message)
            }
        }
    }
    
    func insertMessage(_ message: MockMessage) {
        messages.append(message)
        // Reload last section to update header/footer labels and insert a new one
        messagesCollectionView.performBatchUpdates({
            messagesCollectionView.insertSections([messages.count - 1])
            if messages.count >= 2 {
                messagesCollectionView.reloadSections([messages.count - 2])
            }
        }, completion: { [weak self] _ in
            if self?.isLastSectionVisible() == true {
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        })
    }
    
    func isLastSectionVisible() -> Bool {
        
        guard !messages.isEmpty else { return false }
        
        let lastIndexPath = IndexPath(item: 0, section: messages.count - 1)
        
        return messagesCollectionView.indexPathsForVisibleItems.contains(lastIndexPath)
    }
    
    func processInputBar(_ inputBar: InputBarAccessoryView) {
        // Here we can parse for which substrings were autocompleted
        let attributedText = inputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        inputBar.inputTextView.text = String()
        inputBar.invalidatePlugins()
        // Send button activity animation
        inputBar.sendButton.startAnimating()
        inputBar.inputTextView.placeholder = "Sending..."
        // Resign first responder for iPad split view
        inputBar.inputTextView.resignFirstResponder()
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                inputBar.sendButton.stopAnimating()
                inputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToLastItem(animated: true)
            }
        }
    }
}

extension InsideChatViewController: MessagesDisplayDelegate {
    
    // MARK: - 말풍선 꼬리
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        
        let tail: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        
        return .bubbleTail(tail, .curved)
    }
    
    // 말풍선 배경색상
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 255/255, green: 125/255, blue: 50/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    
    
}

extension InsideChatViewController: MessagesLayoutDelegate{
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func cellBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 17
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 20
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}
