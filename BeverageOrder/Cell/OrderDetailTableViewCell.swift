//
//  OrdetailTableViewCell.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/16.
//

import UIKit

class OrderDetailTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
