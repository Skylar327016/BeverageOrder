//
//  CollectionViewCell.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/18.
//

import UIKit

class ShopCollectionViewCell: UICollectionViewCell {
    struct PropertyKey {
        static let cell = "shopcell"
    }
    @IBOutlet weak var shopImageView: UIImageView!
}
