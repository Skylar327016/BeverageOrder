//
//  ShopViewController.swift
//  BeverageOrder
//
//  Created by 陳家豪 on 2020/8/18.
//

import UIKit

class ShopViewController: UIViewController {
    
    var groupName:String!
    var password: String!
    var shops = [Shop]()
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        getShops()
    }
    func getShops(){
        let shop1 = Shop(shopName: "一手私藏世界紅茶", shopLogo: UIImage(named: "一手私藏世界紅茶")!)
        let shop2 = Shop(shopName: "五十嵐", shopLogo: UIImage(named: "五十嵐")!)
        let shop3 = Shop(shopName: "可不可熟成紅茶", shopLogo: UIImage(named: "可不可熟成紅茶")!)
        let shop4 = Shop(shopName: "茶聚i-partea", shopLogo: UIImage(named: "茶聚i-partea")!)
        let shop5 = Shop(shopName: "一芳水果茶", shopLogo: UIImage(named: "一芳水果茶")!)
        let shop6 = Shop(shopName: "大苑子", shopLogo: UIImage(named: "大苑子")!)
        let shop7 = Shop(shopName: "迷客夏", shopLogo: UIImage(named: "迷客夏")!)
        
        shops.append(shop1)
        shops.append(shop2)
        shops.append(shop3)
        shops.append(shop4)
        shops.append(shop5)
        shops.append(shop6)
        shops.append(shop7)
    }
    override func viewDidLayoutSubviews() {
        configureCell()
    }
    
    func configureCell() {
        let itemSpace: CGFloat = 3
        let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        let width = floor((collectionView.bounds.width - itemSpace) / 2)
        let height = floor(width * 131 / 111) 
        flowLayout?.itemSize = CGSize(width: width, height: height)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = itemSpace
        flowLayout?.minimumLineSpacing = itemSpace
    }
    
    func configure(for cell: ShopCollectionViewCell, at indexPath: IndexPath) {
        cell.shopImageView.image = shops[indexPath.row].shopLogo
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToOrder" {
            guard let groupDetail = sender as? GroupDetail else {return}
            guard let controller = segue.destination as? OrderViewController else {return}
            controller.groupDetail = groupDetail
        }
    }

}

extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shops.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopCollectionViewCell.PropertyKey.cell, for: indexPath) as? ShopCollectionViewCell else {return UICollectionViewCell()}
        configure(for: cell, at: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedShop = shops[indexPath.row]
        let groupDetail = GroupDetail(groupName: groupName, shopName: selectedShop.shopName, password: password)
        performSegue(withIdentifier: "goToOrder", sender: groupDetail)
    }
    
}
