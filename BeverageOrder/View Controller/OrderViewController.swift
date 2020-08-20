//
//  ViewController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/16.
//

import UIKit

class OrderViewController: UIViewController {
    
    @IBOutlet weak var groupNameTextField: UITextField!
    @IBOutlet weak var shopNameTextField: UITextField!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var beverageTextField: UITextField!
    @IBOutlet weak var sugarSegmentedControl: UISegmentedControl!
    @IBOutlet weak var iceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var extraBubbleSwitch: UISwitch!
    var pickerField:UITextField!
    var beverageList = [Beverage]()
    var beverageSelection:Int!
    let sugarChoices = ["正常糖", "少糖", "半糖", "微糖", "無糖"]
    let iceChoices = ["正常冰", "少冰", "微冰", "去冰", "熱"]
    var groupDetail: GroupDetail!
    var unfinishedOrderDetails = [OrderDetail]()
    var customers = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
        OrderDetailController.shared.fetchOrderDetails { (unfinishedOrderDetails, _) in
            guard let unfinishedOrderDetails = unfinishedOrderDetails else { return }
            for orderDetail in unfinishedOrderDetails {
                let name = orderDetail.name
                self.customers.append(name)
            }
        }
        beverageList.append(Beverage(name: "請選擇飲料", price: 0))
        beverageTextField.delegate = self
        nameTextField.delegate = self
//        BeverageController.shared.fetchBeverageList { (beverageList) in
//            guard let beverageList = beverageList else {return}
//            self.beverageList += beverageList
//        }
        print("被選到的是\(groupDetail.shopName)")
        BeverageController.shared.fetchBeverageList(with: groupDetail.shopName) { (beverageList) in
            guard let beverageList = beverageList else {return}
            self.beverageList += beverageList
        }
        setViews()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            self.view.endEditing(true)
    }
    func setViews() {
        groupNameTextField.text = groupDetail.groupName
        shopNameTextField.text = groupDetail.shopName
        guard let logoImage = UIImage(named: "\(groupDetail.shopName)") else {return}
        logoImageView.image = logoImage
        logoImageView.layer.cornerRadius = logoImageView.frame.width / 2
    }
    @IBAction func submitOrder(_ sender: UIButton) {
        if nameTextField.text == "" {
            Tool.shared.showAlert(in: self, with: "請輸入姓名")
        }else if customers.contains(nameTextField.text!){
            Tool.shared.showAlert(in: self, with: "已有其他人使用此名稱，請輸入其他名稱")
        }else if beverageSelection == nil || beverageSelection == 0 {
            Tool.shared.showAlert(in: self, with: "請輸入要喝的飲料")
        }else {
            var orderData = OrderData(data: [])
            let name = nameTextField.text!
            let beverageName = beverageTextField.text!
            let sugarPreference = sugarChoices[sugarSegmentedControl.selectedSegmentIndex]
            let icePreference = iceChoices[iceSegmentedControl.selectedSegmentIndex]
            let extraBubble = "\(extraBubbleSwitch.isOn)"
            let orderDate = Tool.shared.formatDate(with: Date())
print("orderDate in create = \(orderDate)")
            var price: String{
                if extraBubbleSwitch.isOn{
                    return "\(beverageList[beverageSelection].price + 5)"
                }else{
                    return "\(beverageList[beverageSelection].price)"
                }
            }
            let orderDetail = OrderDetail(groupName: groupDetail.groupName, shopName: groupDetail.shopName, name: name, beverageName: beverageName, sugarPreference: sugarPreference, icePreference: icePreference, extraBubble: extraBubble, price: price, orderDate: orderDate, isFinished: "FALSE")
            orderData.data.append(orderDetail)
print("orderDetail before upload = \(orderDetail)")
            OrderDetailController.shared.submitOrderDetail(with: orderData) { [self] (success) in
                guard let success = success else {return}
                if success {
                    DispatchQueue.main.async {
                        Tool.shared.showResultAndToRoot(in: self, with: "訂單送出成功")
                    }
                   
                }else {
                    DispatchQueue.main.async {
                        Tool.shared.showAlert(in: self, with: "訂單送出失敗")
                    }
                   
                }
                
            }
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

extension OrderViewController:UIPickerViewDelegate, UIPickerViewDataSource{
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

extension OrderViewController: UITextFieldDelegate {
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
