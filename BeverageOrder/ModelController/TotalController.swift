//
//  TotalController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/17.
//

import Foundation
struct TotalController {
    static let shared = TotalController()
    func getTotals(from subtotals: [Subtotal], completionHangler: @escaping ([Total]?) -> Void) {
        var totals = [Total]()
        for subtotal in subtotals {
            if totals.count == 0 {
                let subtotalArray = [subtotal]
                let total = Total(subtotals: subtotalArray)
                totals.append(total)

            }else {
                for i in 0...totals.count-1 {
                    if subtotal == totals[i].subtotals[0] {
                        totals[i].subtotals.append(subtotal)
                        break
                    }else if i == totals.count-1{
                        let subtotalArray = [subtotal]
                        let total = Total(subtotals: subtotalArray)
                        totals.append(total)
                    }
                    
                }
                
            }
        }
        completionHangler(totals)
    }
    
}
