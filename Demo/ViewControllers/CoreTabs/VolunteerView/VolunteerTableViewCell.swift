//
//  VolunteerTableViewCell.swift
//  Demo
//
//  Created by Sun hee Bae on 2021/02/03.
//

import UIKit


class VolunteerTableViewCell: UITableViewCell {

    
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
