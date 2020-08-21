//
//  Order.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/19.
//

import Foundation
struct Order: Equatable {
    var orderDetails: [OrderDetail]
    var groupName: String {
        return orderDetails[0].groupName
    }
    var shopName: String {
        return orderDetails[0].shopName
    }
    
}
