//
//  SummaryTableViewController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/17.
//

import UIKit

class SummaryTableViewController: UITableViewController {
    
    var totals = [Total]()
    var orderDetails = [OrderDetail]()
    var heightForSection:CGFloat = 0.0
    @IBOutlet weak var totalNumberLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateDataSource()
        
    }
    override func viewDidLayoutSubviews() {
        setViews()
    }
    func setViews(){
        tableView.separatorStyle = .none
        totalNumberLabel.text = OrderController.shared.getTotalNumber(from: orderDetails)
        totalPriceLabel.text = OrderController.shared.getTotalPrice(from: orderDetails)
        guard let image = UIImage(named: "\(OrderController.shared.getImageNameString(from: orderDetails))") else {return}
        logoImageView.image = image
        logoImageView.layer.cornerRadius = logoImageView.frame.height / 2
//        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
//        heightForSection = cell.bounds.height
        heightForSection = CGFloat(view.frame.height / 12)
    }
    func updateDataSource() {
        SubtotalController.shared.getSubtotals(from: orderDetails) { (subtotals) in
            guard let subtotals = subtotals else {return}
            TotalController.shared.getTotals(from: subtotals) { (totals) in
                guard let totals = totals else {return}
                self.totals = totals
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    print("totals = \(totals)")
                }
            }
        }
    }
    func configure(for cell: SummaryTableViewCell, at indexPath: IndexPath) {
        cell.customisedBeverageLabel.text = totals[indexPath.section].subtotals[indexPath.row].customisedBeverage
        cell.selectionStyle = .none
    }
//    func getTotalPrice(){
//        var totalPrice: Int {
//            var totalPrice = 0
//            for total in totals {
//                totalPrice += total.totalPrice
//            }
//            return totalPrice
//        }
//        print("總計: \(totalPrice)元")
//    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return totals.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return totals[section].subtotals.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) as? SummaryTableViewCell else {return UITableViewCell()}
        configure(for: cell, at: indexPath)
        return cell
    }
//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return totals[section].beverageName + "共\(totals[section].totalNumber)杯"
//    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let total = totals[section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell") as! HeaderTableViewCell
        cell.setUp(with: total)
        return cell.contentView
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return heightForSection
    }
    
    
}
