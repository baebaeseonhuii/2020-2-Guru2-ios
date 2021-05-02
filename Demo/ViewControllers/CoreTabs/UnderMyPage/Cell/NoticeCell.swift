//
//  NoticeCell.swift
//  Demo
//
//  Created by apple on 2021/02/09.
//

import UIKit

class NoticeCell: UITableViewCell {

    @IBOutlet weak var noticeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
