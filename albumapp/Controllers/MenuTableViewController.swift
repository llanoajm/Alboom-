//
//  MenuTableViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 22/11/20.
//

import UIKit

class MenuTableViewController: UITableViewController {

//    let collectionVC = CollectionViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let menuCell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
       
        if indexPath.row == 0{
            menuCell.textLabel?.text = "Menu Cell"
            menuCell.isUserInteractionEnabled = false
            
        }
        else if indexPath.row == 1{
            menuCell.textLabel?.text = "Grid"
        }
        return menuCell
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        collectionVC.gridIsSelected = false
//        collectionVC.collectionView.reloadData()
    }

}
