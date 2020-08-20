//
//  UpdateOrderViewController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/17.
//

import UIKit

class UpdateOrderViewController: UIViewController {
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var beverageTextField: UITextField!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var extraBubbleSwitch: UISwitch!
    var orderDetailWillUpdate: OrderDetail!
    var pickerField:UITextField!
    var beverageList = [Beverage]()
    var beverageSelection:Int!
    let sugarChoices = ["正常糖", "少糖", "半糖", "微糖", "無糖"]
    let iceChoices = ["正常冰", "少冰", "微冰", "去冰", "熱"]
    var lastController: OrderDetailViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        beverageList.append(Beverage(name: "請選擇飲料", price: 0))
        beverageTextField.delegate = self
        nameTextField.delegate = self
        BeverageController.shared.fetchBeverageList(with: orderDetailWillUpdate.shopName) { (beverageList) in
            guard let beverageList = beverageList else {return}
            self.beverageList += beverageList
        }
        beverageSelection = getSelectionInBeverageList(with: orderDetailWillUpdate.beverageName)
        showOrdetailInfo(with: orderDetailWillUpdate)
    }

    @IBAction func updateOrderDetail(_ sender: UIButton) {
        print("updateButtonClicked")
        if beverageSelection == nil || beverageSelection == 0 {
            Tool.shared.showAlert(in: self, with: "請輸入要喝的飲料")
        }else {
            var orderData = OrderData(data: [])
            let groupName = groupNameTextField.text!
            let shopName = shopNameTextField.text!
            let name = nameTextField.text!
            let beverageName = beverageTextField.text!
            let sugarPreference = sugarChoices[sugarSegmentedControl.selectedSegmentIndex]
            let icePreference = iceChoices[iceSegmentedControl.selectedSegmentIndex]
            let extraBubble = "\(extraBubbleSwitch.isOn)"
            var price: String{
                if extraBubbleSwitch.isOn{
                    return "\(beverageList[beverageSelection].price + 5)"
                }else{
                    return "\(beverageList[beverageSelection].price)"
                }
            }
            let orderDetail = OrderDetail(groupName: groupName, shopName: shopName, name: name, beverageName: beverageName, sugarPreference: sugarPreference, icePreference: icePreference, extraBubble: extraBubble, price: price, orderDate: orderDetailWillUpdate.orderDate, isFinished: "FALSE")
            orderData.data.append(orderDetail)
            OrderDetailController.shared.updateOrderDetail(with: orderData) { [self] (success) in
                guard let success = success else {return}
                if success {
                    DispatchQueue.main.async {
                        Tool.shared.showAlert(in: self, with: "訂單修改成功") { (true) in
                            self.dismiss(animated: true) {
                                self.lastController?.updateData()
                            }
                        }
                        
                    }
                   
                }else {
                    DispatchQueue.main.async {
                        Tool.shared.showAlert(in: self, with: "訂單修改失敗") { (true) in
                            self.dismiss(animated: true) {
                                self.lastController?.updateData()
                            }
                        }
                        
                    }
                   
                }
            }
        }
    }
    func showOrdetailInfo(with willUpdateOrderdetail: OrderDetail) {
        groupNameTextField.text = willUpdateOrderdetail.groupName
        shopNameTextField.text = willUpdateOrderdetail.shopName
        nameTextField.text = willUpdateOrderdetail.name
        beverageTextField.text = willUpdateOrderdetail.beverageName
        sugarSegmentedControl.selectedSegmentIndex = getSugarIndex(from: willUpdateOrderdetail.sugarPreference)
        iceSegmentedControl.selectedSegmentIndex = getIceIndex(from: willUpdateOrderdetail.icePreference)
        extraBubbleSwitch.isOn = getSwitchBool(from: willUpdateOrderdetail.extraBubble)
        guard let logoImage = UIImage(named: "\(willUpdateOrderdetail.shopName)") else {return}
        logoImageView.image = logoImage
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
    }
    func getSelectionInBeverageList(with beverageName: String) -> Int {
        var beverageSelection = 0
        for i in 0...beverageList.count - 1 {
            if beverageName == beverageList[i].name{
                beverageSelection = i
            }
        }
        return beverageSelection
    }
    func getSugarIndex(from sugarPreference: String) -> Int {
        var sugarIndex = 0
        for index in 0...sugarChoices.count-1 {
            if sugarChoices[index] == sugarPreference {
                sugarIndex = index
                break
            }
        }
        return sugarIndex
    }
    func getIceIndex(from icePreference: String) -> Int {
        var iceIndex = 0
        for index in 0...iceChoices.count-1 {
            if iceChoices[index] == icePreference {
                iceIndex = index
                break
            }
        }
        return iceIndex
    }
    func getSwitchBool(from boolString: String) -> Bool {
        if boolString.uppercased() == "TRUE" {
            return true
        }else {
            return false
        }
    }
    func initPickerView(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "確認", style: .plain, target: self, action: #selector(confirmSelection))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(cancelSelection))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        pickerField = UITextField(frame: CGRect.zero)
        view.addSubview(pickerField)
        pickerField.inputView = pickerView
        pickerField.inputAccessoryView = toolBar
        pickerField.becomeFirstResponder()
    }
    @objc func confirmSelection(){
        if let selection = beverageSelection{
            if selection != 0{
                DispatchQueue.main.async {
                    self.beverageTextField.text = self.beverageList[selection].name
                    self.pickerField.resignFirstResponder()
                }
            }else{
                self.beverageTextField.text = ""
                self.pickerField.resignFirstResponder()
            }
        }else{
            DispatchQueue.main.async {
                self.pickerField.resignFirstResponder()
            }
        }
    }
    @objc func cancelSelection(){
        self.pickerField.resignFirstResponder()
    }
}

extension UpdateOrderViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == nameTextField {
            nameTextField.becomeFirstResponder()
        }else {
            DispatchQueue.main.async {
                self.initPickerView()
            }
        }
       
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension UpdateOrderViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return beverageList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return beverageList[row].name
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.beverageSelection = row
    }

}
