//
//  Shop.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/18.
//

import Foundation
import UIKit
struct Shop {
    var shopName: String
    var shopLogo: UIImage
    var shopCode: String {
        switch shopName {
        case "一手私藏世界紅茶" :
            return "oneHand"
        case "五十嵐":
            return "50"
        case "茶聚i-partea" :
            return "partea"
        case "一芳水果茶":
            return "yifang"
        case "可不可熟成紅茶":
            return "kebuke"
        case "大苑子":
            return "dayungs"
        case "迷客夏":
            return "milkshop"
        default:
            return ""
        }
    }
}
