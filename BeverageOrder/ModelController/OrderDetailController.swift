//
//  OrdetailController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/16.
//

import Foundation
struct OrderDetailController {
    static let shared = OrderDetailController()
    var baseUrlString = "https://sheetdb.io/api/v1/qfkcavuwvptm5"
    var baseRequest = URLRequest(url: URL(string: "https://sheetdb.io/api/v1/qfkcavuwvptm5")!)
    
    func submitOrderDetail(with orderData: OrderData, completionHandler: @escaping(Bool?) -> Void){
        var request = baseRequest
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(orderData){
            URLSession.shared.uploadTask(with: request, from: data) { (returnData, response, error) in
                let decoder = JSONDecoder()
                if let returnData = returnData, let dictionary = try? decoder.decode([String: Int].self, from: returnData), dictionary["created"] == 1{
                    print("Upload successfully")
                    completionHandler(true)
                }else{
                    print("upload failed")
                    completionHandler(false)
                }
            }.resume()
        }
        
    }
    
    func fetchOrderDetails(completionHandler: @escaping([OrderDetail]?, [OrderDetail]?) -> Void){
        var request = baseRequest
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print("error = \(error?.localizedDescription)")
            }
            let decoder = JSONDecoder()
            if let data = data, let allOrderDetails = try? decoder.decode([OrderDetail]?.self, from: data){
                var unFinishedOrderDetails = [OrderDetail]()
                var finishedOrderDetails = [OrderDetail]()
                allOrderDetails.forEach({ (orderDetail) in
                    let unfinished = orderDetail.isFinished.uppercased() == "FALSE"
                    if unfinished{
                        unFinishedOrderDetails.append(orderDetail)
                    }else{
                        finishedOrderDetails.append(orderDetail)
                    }
                })
                if unFinishedOrderDetails.count != 0 || finishedOrderDetails.count != 0{
                    completionHandler(unFinishedOrderDetails, finishedOrderDetails)
                }else {
                    completionHandler(nil, nil)
                }
                
            }else{
                completionHandler(nil,nil)
            }
        }.resume()
    }
    
    func deleteOrderDetail(with name: String, completionHandler: @escaping (Bool) -> Void) {
        var deleteUrlString = baseUrlString
        deleteUrlString += ("/name/\(name)")
        if let urlString = deleteUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlString){
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            URLSession.shared.dataTask(with: request) { (returnData, response, error) in
                if error != nil {
                    print("error = \(error?.localizedDescription)")
                }
                let decoder = JSONDecoder()
                if let returnData = returnData, let dictionary = try? decoder.decode([String: Int].self, from: returnData), dictionary["deleted"] != nil{
                    print("Delete successfully")
                    completionHandler(true)
                }else{
                    print("Delete failed")
                    completionHandler(false)
                }
            }.resume()
            
        }
    }
    func updateOrderDetail(with orderData: OrderData, completionHandler: @escaping (Bool?) -> Void) {
            var updateUrlString = baseUrlString
        updateUrlString += ("/name/\(orderData.data[0].name)")
            if let urlString = updateUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.httpMethod = "PUT"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let encoder = JSONEncoder()
                if let data = try? encoder.encode(orderData) {
                    URLSession.shared.uploadTask(with: request, from: data) { (returnData, response, error) in
                        if error != nil {
                            print("error = \(error?.localizedDescription)")
                        }
                        let decoder = JSONDecoder()
                        if let returnData = returnData, let dictionary = try? decoder.decode([String: Int].self, from: returnData) {
                            if dictionary["updated"] != nil {
                                print("Updated Successfully")
                                completionHandler(true)
                            }else {
                                print("Update failed")
                                completionHandler(false)
                            }
                        }
                    }.resume()
                }         
            }
    }
    func finishOrderDetails(with orderData: OrderData, completionHandler: @escaping (Bool?) -> Void) {
            var updateUrlString = baseUrlString
        updateUrlString += ("/name/\(orderData.data[0].name)")
            if let urlString = updateUrlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.httpMethod = "PATCH"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                let encoder = JSONEncoder()
                if let data = try? encoder.encode(orderData) {
print("get JSONData")
                    URLSession.shared.uploadTask(with: request, from: data) { (returnData, response, error) in
print("performing task")
                        if error != nil {
                            print("error = \(error?.localizedDescription)")
                        }
                        let decoder = JSONDecoder()
                        if let returnData = returnData {
                            let dictionary = try! decoder.decode([String: Int].self, from: returnData)
                            if dictionary["updated"] != nil {
                                let row = dictionary["updated"]
                                print("row = \(row)")
                                print("Updated Successfully")
                                completionHandler(true)
                            }else {
                                print("Update failed")
                                completionHandler(false)
                            }
                        }
                    }.resume()
                }
            }
    }
    
}
