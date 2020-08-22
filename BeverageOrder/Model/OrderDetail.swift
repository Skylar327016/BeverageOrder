//
//  OrderDetail.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/16.
//

import Foundation
struct OrderData: Codable {
    var data: [OrderDetail]
}
struct OrderDetail: Codable, Equatable {
    var groupName: String
    var shopName: String
    var password: String
    var name: String
    var beverageName: String
    var sugarPreference: String
    var icePreference: String
    var extraBubble: String
    var price: String
    var isFinished: String
     
    static func == (lhs: OrderDetail, rhs: OrderDetail) -> Bool {
        if lhs.groupName == rhs.groupName && lhs.shopName == rhs.shopName  && lhs.beverageName == rhs.beverageName && lhs.sugarPreference == rhs.sugarPreference && lhs.icePreference == rhs.icePreference && lhs.extraBubble == rhs.extraBubble && lhs.price == rhs.price && lhs.isFinished == rhs.isFinished {
            return true
        }else {
            return false
        }
   }
}


