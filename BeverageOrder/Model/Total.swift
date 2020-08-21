//
//  Total.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/17.
//

import Foundation
struct Total: Equatable {

    var groupName: String {
        return subtotals[0].groupName
    }
    var shopName: String {
        return subtotals[0].shopName
    }
    var isFinished: String {
        return subtotals[0].isFinished
    }
    var subtotals: [Subtotal]
    var beverageName:String {
        return subtotals[0].orderDetails[0].beverageName
    }
    var totalNumber:Int {
        var totalNumber = 0
        for subtotal in subtotals {
            totalNumber += subtotal.number
        }
        return totalNumber
    }
    var totalPrice:Int {
        var totalPrice = 0
        for subtotal in subtotals {
            totalPrice += subtotal.subTotalPrice
        }
        return totalPrice
    }
    static func == (lhs: Total, rhs: Total) -> Bool {
        if lhs.groupName == rhs.groupName && lhs.shopName == rhs.shopName && lhs.isFinished == rhs.isFinished {
            return true
        }else {
            return false
        }
    }
}
