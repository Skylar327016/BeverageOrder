//
//  SummaryController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/17.
//

import Foundation
struct SubtotalController {
    static let shared = SubtotalController()
    
    func getSubtotals(from orderDetails: [OrderDetail], completionHangler: @escaping ([Subtotal]?) -> Void) {
        var subtotals = [Subtotal]()
        for orderDetail in orderDetails {
            if subtotals.count == 0 {
                let orderDetailArray = [orderDetail]
                let subtotal = Subtotal(orderDetails: orderDetailArray)
                subtotals.append(subtotal)

            }else {
                for i in 0...subtotals.count-1 {
                    if orderDetail == subtotals[i].orderDetails[0]{
                        subtotals[i].orderDetails.append(orderDetail)
                        break
                    }else if i == subtotals.count-1 {
                        let orderDetailArray = [orderDetail]
                        let subtotal = Subtotal(orderDetails: orderDetailArray)
                        subtotals.append(subtotal)
                    }
                }
                
            }
        }
 print("subtotals.count = \(subtotals.count)")
        completionHangler(subtotals)
    }
}
