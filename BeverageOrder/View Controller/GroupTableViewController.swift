//
//  GroupTableViewController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/19.
//

import UIKit

class GroupTableViewController: UITableViewController {
    
    var stillLoadingOrNot: Bool!
    var loadingView = UIActivityIndicatorView()
    var orders = [Order]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        loadingView = Tool.shared.setLoadingView(in: self, with: loadingView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        stillLoadingOrNot = true
        Tool.shared.loading(activity: loadingView, is: stillLoadingOrNot)
        loadFinishedGroupDetails()
    }
    func loadFinishedGroupDetails(){
        OrderDetailController.shared.fetchOrderDetails { [self] (_, finishedOrderDetails) in
            guard let finishedOrderDetails = finishedOrderDetails, finishedOrderDetails.count > 0 else {
                stillLoadingOrNot = false
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    Tool.shared.loading(activity: loadingView, is: stillLoadingOrNot)
                }
                return
            }
            OrderController.shared.getOrders(from: finishedOrderDetails) { (orders) in
                guard let orders = orders else {
                    stillLoadingOrNot = false
                    Tool.shared.loading(activity: loadingView, is: stillLoadingOrNot)
                    return
                }
                self.orders = orders
                stillLoadingOrNot = false
print("orders = \(orders)")
print("orders[0] = \(orders[0].orderDetails)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    Tool.shared.loading(activity: loadingView, is: stillLoadingOrNot)
                }
            }
        }

    }

    func configure(with orders: [Order],for cell: GroupTableViewCell, at row:Int){
        let order = orders[row]
        cell.nameTitleLabel.text = "班期名稱："
        guard let logoImage = UIImage(named: "\(order.shopName)") else {return}
        cell.logoImageView.image = logoImage
        cell.groupNameLabel.text = order.groupName
        cell.logoImageView.layer.cornerRadius = cell.logoImageView.frame.width / 2
        cell.selectionStyle = .none
        cell.accessoryType = .disclosureIndicator
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if orders.count == 0 {
            return 1
        }else {
            return orders.count
        }
        
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupTableViewCell else {return UITableViewCell()}
        if orders.count == 0{
            cell.logoImageView.image = UIImage(named: "Peter")
            cell.groupNameLabel.text = "尚無訂購紀錄"
            cell.accessoryType = .none
            cell.selectionStyle = .none
        }else {
            configure(with: orders, for: cell, at: indexPath.row)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetails = orders[indexPath.row].orderDetails
        performSegue(withIdentifier: "toOrderDetail", sender: orderDetails)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toOrderDetail" {
            guard let controller = segue.destination as? SummaryTableViewController else {return}
            guard let orderDetails = sender as? [OrderDetail] else {return}
print("要傳送的orderDetails = \(orderDetails)")
            controller.orderDetails = orderDetails
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
