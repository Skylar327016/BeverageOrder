//
//  GroupDetailController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/18.
//

import Foundation
struct GroupDetailController {
    static let shared = GroupDetailController()
    func fetchGroupDetail(with unFinishedOrderDetails: [OrderDetail],and finishedOrderDetails: [OrderDetail], completionHandler: @escaping ([GroupDetail]?, [GroupDetail]?) -> Void) {
        let unFinishedGroupDetails = turnToGroupDetails(with: unFinishedOrderDetails)
        let finishedGroupDetails = turnToGroupDetails(with: finishedOrderDetails)
print("unFinishedGroupDetails = \(unFinishedGroupDetails)")
print("finishedGroupDetails = \(finishedGroupDetails)")
        completionHandler(unFinishedGroupDetails, finishedGroupDetails )
        
    }
    
    
    func turnToGroupDetails(with orderDetails:[OrderDetail]) -> [GroupDetail] {
        var groupDetails = [GroupDetail]()
        for orderDetail in orderDetails {
            if groupDetails.count == 0 {
                let groupName = orderDetail.groupName
                let shopName = orderDetail.shopName
                let password = orderDetail.password
                let groupDetail = GroupDetail(groupName: groupName, shopName: shopName, password: password)
                groupDetails.append(groupDetail)
            }else{
                let groupName = orderDetail.groupName
                let shopName = orderDetail.shopName
                let password = orderDetail.password
                let groupDetail = GroupDetail(groupName: groupName, shopName: shopName, password: password)
                for i in 0...groupDetails.count - 1 {
                    if groupDetail == groupDetails[i] {
                        break
                    }else if i == groupDetails.count - 1 {
                        groupDetails.append(groupDetail)
                    }
                }
            }
        }
        return groupDetails
    }
 
    func finishOrderDetails(with groupDetail:GroupDetail, and unfinishedOrderDetails: [OrderDetail], completionHandler: @escaping ([OrderDetail]?) -> Void) {
        let groupName = groupDetail.groupName
        let shopName = groupDetail.shopName
        var willFinishOrderDetails = [OrderDetail]()
        unfinishedOrderDetails.forEach { (orderDetail) in
            if orderDetail.groupName == groupName && orderDetail.shopName == shopName {
                willFinishOrderDetails.append(orderDetail)
            }
        }
        for i in 0...willFinishOrderDetails.count - 1 {
            willFinishOrderDetails[i].isFinished = "TRUE"
        }
print("willFinishOrderDetails.count = \(willFinishOrderDetails.count)")
        if willFinishOrderDetails.count != 0 {
            completionHandler(willFinishOrderDetails)
        }else {
            completionHandler(nil)
        }
    }
}
