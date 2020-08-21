//
//  OrderController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/19.
//

import Foundation

struct OrderController {
    static let shared  = OrderController()
    func getOrders(from orderDetails: [OrderDetail], completion: ([Order]?) -> Void) {
        var orders = [Order]()
        for i in 0...orderDetails.count - 1 {
            let orderDetail = orderDetails[i]
            if orders.count == 0 {
                let order = Order(orderDetails: [orderDetail])
                orders.append(order)
            }else {
                for i in 0...orders.count - 1 {
                    let innerOrderDetail = orders[i].orderDetails[0]
                    if isTheSameOrder(lhs: orderDetail, rhs: innerOrderDetail) {
                        orders[i].orderDetails.append(orderDetail)
                        break
                    }else if i == orders.count - 1 {
                        let order = Order(orderDetails: [orderDetail])
                        orders.append(order)
                    }
                }
            }
            
        }
        completion(orders)
    }
    
    func isTheSameOrder(lhs:OrderDetail, rhs: OrderDetail) -> Bool {
        if lhs.groupName == rhs.groupName && lhs.shopName == rhs.shopName  {
            return true
        }else {
            return false
        }
    }
    func getTotalNumber(from orderDetails: [OrderDetail]) -> String{
        var number = 0
        for _ in 0...orderDetails.count - 1 {
            number += 1
        }
        return String(number)
    }
    func getTotalPrice(from orderDetails: [OrderDetail]) -> String {
        var totalPrice = 0
        for orderDetail in orderDetails {
            totalPrice += Int(orderDetail.price)!
        }
        return String(totalPrice)
    }
    func getImageNameString(from orderDetails: [OrderDetail]) -> String {
        return orderDetails[0].shopName
    }
}
