//
//  NoticeDetailViewController.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit

class NoticeDetailViewController: UIViewController {
    
    @IBOutlet weak var noticeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var mainLabel: UILabel!
    
    
    var notices = ""
    var dates = ""
    var main = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "공지사항"
        self.navigationController?.navigationBar.topItem?.title = ""
        
        noticeLabel.text = notices
        dateLabel.text = dates
        mainLabel.text = main
    }
}
