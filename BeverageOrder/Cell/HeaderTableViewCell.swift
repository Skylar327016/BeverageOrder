//
//  HeaderTableViewCell.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/20.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var line: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    func setUp(with total: Total) {
        line.layer.cornerRadius = 2
        let title = total.beverageName
        let number = total.totalNumber
        titleLabel.text =  "\(title) 共\(number)杯"
    }
    

}
