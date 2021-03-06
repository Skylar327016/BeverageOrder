//
//  HomeViewController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/18.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var groupNameTextField: UITextField!
    var loadingView = UIActivityIndicatorView()
    var stillLoadingOrNot: Bool!
    var pickerField:UITextField!
    var groupDetails = [GroupDetail]()
    var finishedGroupDetails = [GroupDetail]()
    var groupList = [String]()
    var groupSelection:Int!
    var unfinishedOrderDetails = [OrderDetail]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingView = Tool.shared.setLoadingView(in: self, with: loadingView)
        groupNameTextField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        stillLoadingOrNot = true
        Tool.shared.loading(activity: loadingView, is: stillLoadingOrNot)
        loadGroupDetailsAndGroupList()
        groupNameTextField.text  = ""
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        pickerField?.resignFirstResponder()
    }
    func loadGroupDetailsAndGroupList(){ 
        groupList.removeAll()
        groupList.append("請選擇班期")
        OrderDetailController.shared.fetchOrderDetails { (unfinishedOrderDetails, funishedOrderDetails) in
            guard let unfinishedOrderDetails = unfinishedOrderDetails else {
                self.stillLoadingOrNot = false
                DispatchQueue.main.async { [self] in
                    Tool.shared.loading(activity: loadingView, is: stillLoadingOrNot)
                }
                return
            }
            guard let finishedOrderDetails = funishedOrderDetails else {
                self.stillLoadingOrNot = false
                DispatchQueue.main.async { [self] in
                    Tool.shared.loading(activity: loadingView, is: stillLoadingOrNot)
                }
                return
            }
            self.unfinishedOrderDetails = unfinishedOrderDetails

            GroupDetailController.shared.fetchGroupDetail(with: unfinishedOrderDetails, and: finishedOrderDetails) { [self] (groupDetails, finishedGroupDetails) in
                
                guard let groupDetails = groupDetails else {return}
                guard let finishedGroupDetails = finishedGroupDetails else {return}
                self.finishedGroupDetails = finishedGroupDetails
                self.groupDetails = groupDetails
                stillLoadingOrNot = false
                DispatchQueue.main.async { [self] in
                    Tool.shared.loading(activity: loadingView, is: stillLoadingOrNot)
                }
                for groupDetail in groupDetails {
                    self.groupList.append(groupDetail.groupName)
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
        if let selection = groupSelection{
            if selection != 0{
                DispatchQueue.main.async {
                    self.groupNameTextField.text = self.groupList[selection]
                    self.pickerField.resignFirstResponder()
                }
            }else{
                self.groupNameTextField.text = ""
                self.pickerField?.resignFirstResponder()
            }
        }else{
            DispatchQueue.main.async {
                self.pickerField?.resignFirstResponder()
            }
        }
    }
    @objc func cancelSelection(){
        self.pickerField?.resignFirstResponder()
    }
    @IBAction func goToOrder(_ sender: UIButton) {
        guard let selectedGroup = groupNameTextField.text else {return}
        if selectedGroup == "" {
            Tool.shared.showAlert(in: self, with: "請選擇班期！")
        }else if groupList.contains(selectedGroup){
            performSegue(withIdentifier: "goToOrder", sender: groupDetails[groupSelection - 1])
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOrder" {
            guard let groupDetail = sender as? GroupDetail else { return}
            guard let controller = segue.destination as? OrderViewController else {return}
            controller.groupDetail = groupDetail
        }else if segue.identifier == "chooseShop" {
            guard let groupDictionary = sender as? [String:String] else {return}
            guard let controller = segue.destination as? ShopViewController else {return}
            controller.groupName = groupDictionary["groupName"]
            controller.password = groupDictionary["password"]
        }
    }
    @IBAction func newGroup(_ sender: Any) {
        pickerField?.resignFirstResponder()
        let placeHolders = ["ex:iOSApp程式設計入門彼得潘第16期","密碼"]
        Tool.shared.confirmAction(in: self, withTitle: "請輸入你的團訂名稱及密碼", andPlaceholders: placeHolders) { [self] (confirm, inputs) in
            guard let inputs = inputs else {return}
            let groupName = inputs[0]
            let password = inputs[1]
            if confirm {
                if groupName == "" {
                    Tool.shared.showAlert(in: self, with: "請輸入團訂名稱")
                }else if password == "" {
                    Tool.shared.showAlert(in: self, with: "請輸入密碼")
                }else if groupList.contains(groupName) {
                    Tool.shared.showAlert(in: self, with: "班期名稱重複，請重新輸入")
                }else{
                    var groupDictionary = [String:String]()
                    groupDictionary["groupName"] = groupName
                    groupDictionary["password"] = password
                    self.performSegue(withIdentifier: "chooseShop", sender: groupDictionary)
                }
            }else{
                self.dismiss(animated: true, completion: nil)
            }
        }
        

    }
    @IBAction func finishOrder(_ sender: UIBarButtonItem) {
        guard let selectedGroup = groupNameTextField.text else {return}
        if selectedGroup == "" {
            Tool.shared.showAlert(in: self, with: "請選擇團訂名稱！")
        }else if groupList.contains(selectedGroup){
            let willEndGroupDetail = groupDetails[groupSelection - 1]
            let placeholders = ["請輸入團訂密碼"]
            Tool.shared.confirmAction(in: self, withTitle: "結束團訂後將無法修改訂單資料，確定要結束嗎？", andPlaceholders: placeholders) { [self] (confirm, inputs) in
                guard let inputs = inputs else { return}
                let password = inputs[0]
                if password == "" {
                    Tool.shared.showAlert(in: self, with: "請輸入團訂密碼")
                }else if password != willEndGroupDetail.password {
                    Tool.shared.showAlert(in: self, with: "密碼輸入錯誤，請重新輸入")
                }else{
                    if confirm {
                        GroupDetailController.shared.finishOrderDetails(with: willEndGroupDetail, and: unfinishedOrderDetails) { (willFinishOrderDetails) in
    print("willFinishOrderDetails = \(willFinishOrderDetails)")
                            guard let willFinishOrderDetails = willFinishOrderDetails else {return}
                            var count = 0
                            let countWillReach = willFinishOrderDetails.count
                            willFinishOrderDetails.forEach { (orderDetail) in
                                let orderData = OrderData(data: [orderDetail])
                                OrderDetailController.shared.updateOrderDetail(with: orderData) { (_) in
                                    count += 1
                                    if count == countWillReach {
                                        DispatchQueue.main.async {
                                            Tool.shared.showAlert(in: self, with: "已產生訂購單")
                                            groupNameTextField.text = ""
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    

    

}

extension HomeViewController:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return groupList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return groupList[row]
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.groupSelection = row
    }

}

extension HomeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if groupList.count == 1 {
            Tool.shared.showAlert(in: self, with: "目前無團訂資料")
        }else{
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
