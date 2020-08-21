//
//  OrderDetailViewController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/16.
//

import UIKit

class OrderDetailViewController: UIViewController {
   
    @IBOutlet weak var orderDetailTableView: UITableView!
    var orderDetails = [OrderDetail]()
    var filteredOrderDetails = [OrderDetail]()
    var searchController: UISearchController!
    var isShowSearchResult: Bool = false
    var selectedOrderDetail: OrderDetail!
    override func viewDidLoad() {
        super.viewDidLoad()
        updateData()
        initSearchController()
        orderDetailTableView.delegate = self
        orderDetailTableView.dataSource = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateData()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        orderDetailTableView.rowHeight = view.frame.height * 125 / 896
        orderDetailTableView.estimatedRowHeight = 0
        orderDetailTableView.separatorStyle = .none
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    func configure(with orderDetails: [OrderDetail],for cell: OrderDetailTableViewCell, at row:Int){
        let potentialOrderDetail = filteredOrderDetails[row]
        guard let logoImage = UIImage(named: "\(potentialOrderDetail.shopName)") else {return}
        cell.logoImageView.image = logoImage
        cell.groupNameLabel.text = potentialOrderDetail.groupName
        cell.nameLabel.text = potentialOrderDetail.name
        cell.selectionStyle = .none
        cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.width / 2
        
    }
    func updateData(){
        OrderDetailController.shared.fetchOrderDetails(completionHandler: { (allOrderInfo, _) in
            if let allOrderInfo = allOrderInfo{
                self.orderDetails = allOrderInfo
                DispatchQueue.main.async {
                    self.orderDetailTableView.reloadData()
                }
            }
        })
    }
    func initSearchController(){
        // 生成SearchController
               self.searchController = UISearchController(searchResultsController: nil)
               self.searchController.searchBar.placeholder = "請輸入姓名"
               self.searchController.searchBar.sizeToFit()
               self.searchController.searchResultsUpdater = self // 設定代理UISearchResultsUpdating的協議
               self.searchController.searchBar.delegate = self // 設定代理UISearchBarDelegate的協議
               self.searchController.dimsBackgroundDuringPresentation = false // 預設為true，若是沒改為false，則在搜尋時整個TableView的背景顏色會變成灰底的
        // 將searchBar掛載到tableView上
                self.orderDetailTableView.tableHeaderView = self.searchController.searchBar
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toUpdatePage" {
            guard let willUpdateOrderDetail = sender as? OrderDetail, let controller = segue.destination as? UpdateOrderViewController else {return}
            controller.orderDetailWillUpdate = willUpdateOrderDetail
            controller.lastController = self
        }
    }

}
extension OrderDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return orderDetails.count
        if self.isShowSearchResult {
            // 若是有查詢結果則顯示查詢結果集合裡的資料
            return self.filteredOrderDetails.count
        } else {
            //return orderDetails.count
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? OrderDetailTableViewCell else {return UITableViewCell()}
        if self.isShowSearchResult {
                    // 若是有查詢結果則顯示查詢結果集合裡的資料
            configure(with: filteredOrderDetails, for: cell, at: indexPath.row)
        } else {
            //configure(with: orderDetails, for: cell, at: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        tableView.isEditing = true
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedOrderDetail = filteredOrderDetails[indexPath.row]
        print(selectedOrderDetail)
        self.searchController.searchBar.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        selectedOrderDetail = filteredOrderDetails[indexPath.row]
        print(selectedOrderDetail)
        let updateAction = UIContextualAction(style: .normal, title: "修改") { (action, view, completionHandler) in
            guard let selectedOrderDetail = self.selectedOrderDetail else {return}
            self.performSegue(withIdentifier: "toUpdatePage", sender: selectedOrderDetail)
            completionHandler(true)
        }
        let deleteAction = UIContextualAction(style: .destructive, title: "刪除") { [self] (action, view, completionHandler) in
            Tool.shared.confirmAction(in: self, with: "確定要刪除該訂單嗎?") { (confirm) in
                if confirm {
                    let name = orderDetails[indexPath.row].name
                    OrderDetailController.shared.deleteOrderDetail(with: name) { (deleted) in
                        if deleted {
                            //陣列要先移除
                            filteredOrderDetails.remove(at: indexPath.row)
                            DispatchQueue.main.async {
                                Tool.shared.showAlert(in: self, with: "訂單已刪除")
                                orderDetailTableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .top)
                                orderDetailTableView.reloadData()
                            }
                        }
                    }
                    completionHandler(true)
                }else{
                    return
                }
            }
        }
        updateAction.backgroundColor = .systemBlue
        let configuration = UISwipeActionsConfiguration(actions: [updateAction, deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    
}
extension OrderDetailViewController: UISearchBarDelegate, UISearchResultsUpdating {
    // 當在searchBar上開始輸入文字時
        // 當「準備要在searchBar輸入文字時」、「輸入文字時」、「取消時」三個事件都會觸發該delegate
    func updateSearchResults(for searchController: UISearchController) {
        // 若是沒有輸入任何文字或輸入空白則直接返回不做搜尋的動作
                if self.searchController.searchBar.text?.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count == 0 {
                    return
                }
                self.filterDataSource()
    }
    // 過濾被搜陣列裡的資料
        func filterDataSource() {
            // 使用高階函數來過濾掉陣列裡的資料
            self.filteredOrderDetails = orderDetails.filter({ (orderDetail) -> Bool in
                return orderDetail.name.lowercased().range(of: self.searchController.searchBar.text!.lowercased()) != nil
            })
            
            if self.filteredOrderDetails.count > 0 {
                print("過濾結果>0")
                self.isShowSearchResult = true
                self.orderDetailTableView.separatorStyle = UITableViewCell.SeparatorStyle.init(rawValue: 1)! // 顯示TableView的格線
            } else {
                print("過濾結果=0")
                self.orderDetailTableView.separatorStyle = UITableViewCell.SeparatorStyle.none // 移除TableView的格線
                // 可加入一個查找不到的資料的label來告知使用者查不到資料...
                // ...
            }
            self.orderDetailTableView.reloadData()
        }
    // 當在searchBar上開始輸入文字時
        func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            // 選擇不需實作，因有遵守UISearchResultsUpdating協議的話，則輸入文字的當下即會觸發updateSearchResults，所以等同於同一件事做了兩次(可依個人需求決定)
        }
        
        // 點擊searchBar上的取消按鈕
        func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
            // 依個人需求決定如何實作
            isShowSearchResult = false
            self.orderDetailTableView.reloadData()
        }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //選擇不需要執行查詢的動作，因在「輸入文字時」即會觸發updateSearchResults的delegate做查詢的動作(可依個人需求決定如何實作)
        // 關閉瑩幕小鍵盤
        self.searchController.searchBar.resignFirstResponder()
    }
    
}
