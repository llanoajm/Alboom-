//
//  MenuViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 29/11/20.
//

import Foundation
import UIKit

class MenuController: UITableViewController{
    
//    let collectViewC = CollectionViewController()
   
    
    private let menuItems: [String]
        init(with menuItems: [String]){
        self.menuItems = menuItems
        super.init(nibName: nil, bundle: nil)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "tableCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.backgroundColor = .darkGray
        view.backgroundColor = .darkGray
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        cell.backgroundColor = .darkGray
        cell.textLabel?.textColor = .white
        cell.contentView.backgroundColor = .darkGray
        return cell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
//        let cview = collectViewC.collectionView
        
        if menuItems[indexPath.row] == "Post"{
//            let collectionView = CollectionViewController()
//
//            collectionView.gridIsSelected = false
//            collectionView.collectionView.reloadData()
            print("Post option was selected")
        }
    }
}

