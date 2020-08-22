//
//  GroupDetail.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/18.
//

import Foundation
struct GroupDetail: Codable, Equatable {
    var groupName: String
    var shopName: String
    var password: String
    static func == (lhs: GroupDetail, rhs: GroupDetail) -> Bool {
        if lhs.groupName == rhs.groupName && lhs.shopName == rhs.shopName {
            return true
        }else {
            return false
        }
   }
}
