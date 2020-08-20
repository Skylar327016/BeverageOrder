//
//  BeverageController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/16.
//

import Foundation

struct BeverageController{
    static let shared = BeverageController()
    
    func fetchBeverageList(with shopName: String, completionHandler: (([Beverage]?) -> Void)){
        var shopFileName = ""
        switch shopName {
        case "一手私藏世界紅茶" :
            shopFileName = "oneHand"
        case "五十嵐":
            shopFileName = "fifty"
        case "茶聚i-partea" :
            shopFileName = "partea"
        case "一芳水果茶":
            shopFileName = "yifang"
        case "可不可熟成紅茶":
            shopFileName = "kebuke"
        case "大苑子":
            shopFileName = "dayungs"
        case "迷客夏":
            shopFileName = "milkshop"
        default:
            shopFileName = ""
        }
        let beverageUrl = Bundle.main.url(forResource: "\(shopFileName)", withExtension: "plist")!
print("選到的\(shopFileName)已置入url")
        if let data = try? Data(contentsOf: beverageUrl){
            guard let beverageList = try? PropertyListDecoder().decode([Beverage].self, from: data) else{return}
print("產生的list\(beverageList)")
            completionHandler(beverageList)
            print("\(shopName)共有\(beverageList.count)筆資料")
        }else{
print("讀取data失敗")
            completionHandler(nil)
        }
    }
}
