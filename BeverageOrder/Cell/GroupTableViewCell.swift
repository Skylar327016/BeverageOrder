//
//  GroupTableViewCell.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/19.
//

import UIKit

class GroupTableViewCell: UITableViewCell {


    @IBOutlet weak var dateTitleLabel: UILabel!
    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var groupNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
