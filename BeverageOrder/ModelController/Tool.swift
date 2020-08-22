//
//  Tool.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/17.
//

import Foundation
import UIKit
struct Tool {
    static let shared = Tool()
    func showAlert(in viewController: UIViewController, with message: String){
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
        }))
        viewController.present(controller, animated: true, completion: nil)
    }
    func showResultAndToRoot(in viewController: UIViewController, with message: String){
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            guard let navigationViewController = viewController.navigationController else {return}
            navigationViewController.popToRootViewController(animated: true)
        }))
        viewController.present(controller, animated: true, completion: nil)
    }
    
    func showAlert(in viewController: UIViewController, with message: String, completionHandler: @escaping (Bool) -> Void?){
        let controller = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
            completionHandler(true)
        }))
        viewController.present(controller, animated: true, completion: nil)
    }
    
    func confirmAction(in viewController: UIViewController, with question: String, completionHandler: @escaping (Bool) -> Void){
        let controller = UIAlertController(title: nil, message: question, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "確定", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
            completionHandler(true)
        }))
        controller.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
            completionHandler(false)
        }))
        viewController.present(controller, animated: true, completion: nil)
    }
    
    func confirmAction(in viewController: UIViewController, withTitle title: String, andPlaceholders placeHolders: [String],completionHandler: @escaping (Bool, [String]?) -> Void){
        let controller = UIAlertController(title: nil, message: title, preferredStyle: .alert)
        for placeholder in placeHolders {
            controller.addTextField { (textField) in
                textField.placeholder = placeholder
            }
        }
        controller.addAction(UIAlertAction(title: "確定", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
            var inputs = [String]()
            guard let textFields = controller.textFields else {return}
            for textField in textFields {
                inputs.append(textField.text!)
            }
            completionHandler(true, inputs)
        }))
        controller.addAction(UIAlertAction(title: "取消", style: .default, handler: { (_) in
            viewController.dismiss(animated: true, completion: nil)
            completionHandler(false, nil)
        }))
        viewController.present(controller, animated: true, completion: nil)
    }
    func formatDate(with date: Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return formatter.string(from: date)
    }
    
    func setLoadingView(in viewController: UIViewController, with loadingView: UIActivityIndicatorView) -> UIActivityIndicatorView{
        let view = viewController.view!
        let frame = CGRect(origin: .zero, size: viewController.view.frame.size)
        loadingView.frame = frame
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        loadingView.startAnimating()
        loadingView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.5)
        loadingView.color = UIColor(red: CGFloat(255/255), green: CGFloat(214/255), blue: CGFloat(222/255), alpha: 1)
        loadingView.hidesWhenStopped = true
        loadingView.style = .large
        loadingView.alpha = 1
        return loadingView
    }
    
    func setLoadingView(in tableViewController: UITableViewController, with loadingView: UIActivityIndicatorView) -> UIActivityIndicatorView{
        let view = tableViewController.tableView!
        let frame = CGRect(origin: .zero, size: tableViewController.view.frame.size)
        loadingView.frame = frame
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        loadingView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        loadingView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        loadingView.startAnimating()
        loadingView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        loadingView.color = UIColor(red: CGFloat(255/255), green: CGFloat(214/255), blue: CGFloat(222/255), alpha: 1)
        loadingView.hidesWhenStopped = true
        loadingView.style = .large
        loadingView.alpha = 1
        return loadingView
    }
    
    func loading(activity indicator: UIActivityIndicatorView,  is stillLoading:Bool) {
        DispatchQueue.main.async {
            if stillLoading {
                indicator.startAnimating()
                
            }else {
                indicator.stopAnimating()
            }
        }
       
    }
}
