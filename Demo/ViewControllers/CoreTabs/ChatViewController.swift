//
//  ChatViewController.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/01/21.
//

import UIKit
import FirebaseFirestore

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var myTable: UITableView!
    
    let data = ["John Smith"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "채팅"
        
        myTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        myTable.delegate = self
        myTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "John Smith"
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "showDetail", sender: self)
    }
    
    
    
}
