//
//  Subtotal.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/17.
//

import Foundation
struct Subtotal: Codable, Equatable {
    var orderDetails: [OrderDetail]
    var customisedBeverage:String {
        let sugar = orderDetails[0].sugarPreference
        let ice  = orderDetails[0].icePreference
        let extraBubble = orderDetails[0].extraBubble.uppercased() == "TRUE" ? "加珍珠" : ""
        return  sugar + ice + extraBubble + "\(number)杯"
    }
    var beverageName: String {
        return orderDetails[0].beverageName
    }
    var groupName: String {
        return orderDetails[0].groupName
    }
    var shopName: String {
        return orderDetails[0].shopName
    }
    var orderDate: String {
        return orderDetails[0].orderDate
    }
    var isFinished: String {
        return orderDetails[0].isFinished
    }
    var number: Int {
        return orderDetails.count
    }
    var subTotalPrice:Int {
        var subtotalPrice = 0
        for orderDetail in orderDetails {
            guard let price = Int(orderDetail.price) else {return 0}
            subtotalPrice += price
        }
        return subtotalPrice
    }
    static func == (lhs: Subtotal, rhs: Subtotal) -> Bool {
        if lhs.groupName == rhs.groupName && lhs.beverageName == rhs.beverageName && lhs.orderDate == rhs.orderDate && lhs.isFinished == lhs.isFinished {
            return true
        }else { return false}
    }
}
