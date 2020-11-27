//
//  CollectionViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 20/10/20.
//

import UIKit
import SwipeCellKit
import SideMenu

class CollectionViewController: UICollectionViewController {
    var album: String!
    var albumArray:[String] = []
    let defaults = UserDefaults.standard
    var gridIsSelected: Bool = true
    var dataManaging = DataManaging()
    var refreshControl = UIRefreshControl()
    
    private let sideMenu = SideMenuNavigationController(rootViewController: MenuController(with: ["Display Options", "Grid", "Post"] ))
//    var deletingHidden = false
    
    @IBOutlet weak var sideBarBurger: UIBarButtonItem!
    
    @IBOutlet weak var albumIcon: UIImageView!
    
    @IBOutlet weak var middleLabel: UILabel!
    
    @IBOutlet weak var txtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataManaging.delegate = self
        
        
        sideMenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        //Setting albumsArray to equal the array in UserDefaults.
        if let items = (defaults.array(forKey: "AlbumsArray") as? [String]){
            albumArray = items
            if albumArray.contains("Janet Weaver"){
                print("IT DOES")
            }
            else{
                dataManaging.fetchData()
                print("What?")
            }
        }
        
        if albumArray.count == 0{
            middleLabel.text = "Add your first album"
        }
        else{
            middleLabel.text = ""
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           collectionView.addSubview(refreshControl)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! SwipeCollectionViewCell
        
        albumCell.delegate = self
        
        let label = albumCell.viewWithTag(1) as! UILabel
        
        label.text = albumArray[indexPath.row]
        
        if gridIsSelected == false{
            let albumIcon = albumCell.viewWithTag(20) as! UIImageView
            
            var photoArray = ["String"]
            
            if let items = (defaults.array(forKey: album) as? [String]){
            photoArray = items}
            
            let pacount = photoArray.count - 1
            
            let randomInt = Int.random(in: 0...pacount)
            
            if photoArray.count != 0{
                albumIcon.image = UIImage(contentsOfFile: photoArray[randomInt])
                
            }
            
            
            
            collectionView.reloadData()
        }
        else if gridIsSelected == false{
            
        }
//            albumCell.configure(with: albumArray[indexPath.row])
        
        return albumCell
        
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        album = albumArray[indexPath.row]

        print("didSelectItem")
        performSegue(withIdentifier: "AlbumToPhoto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumToPhoto"{
            let photoVC = segue.destination as! PhotosViewController
            photoVC.album = self.album
            photoVC.commentKey = "commentsFor" + self.album
            
        }
    }
    
    //MARK - Add New Albums
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Album", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //What will happen when the user clicks on the action.
            self.albumArray.append(textField.text ?? "New Album")
            
            self.defaults.set(self.albumArray, forKey: "AlbumsArray")
            
            self.defaults.set(nil, forKey: textField.text!)
            
            self.collectionView.reloadData()
            
            if self.albumArray.count == 0{
                self.middleLabel.text = "Add your first album"
            }
            else{
                self.middleLabel.text = ""
            }

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a title to your album"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func startDeletingPressed(_ sender: Any) {
//        if deletingHidden == true{
//            deletingHidden = false
//
//        }
//        else if deletingHidden == false{
//            deletingHidden = true
//
//        }

    }
    
    @IBAction func burgerTapped(_ sender: UIBarButtonItem) {
        present(sideMenu, animated: true)
    }
    @objc func refresh(_ sender: AnyObject) {
        collectionView.reloadData()
    }
}

extension CollectionViewController: SwipeCollectionViewCellDelegate{
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var action = [SwipeAction]()
//        guard orientation == .right else { return nil }
        
        let editAction = SwipeAction(style: .default, title: "Show Photo Instead") { [self] action, indexPath in
            
            let alert = UIAlertController(title: "Show Preview Of Album?", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                
                let albumCell = collectionView.cellForItem(at: indexPath)
                
                let albumIcon = albumCell?.viewWithTag(20) as! UIImageView
                
                var photoArray = ["String"]
                
                if let items = (defaults.array(forKey: album) as? [String]){
                photoArray = items}
                
                let pacount = photoArray.count - 1
                
                let randomInt = Int.random(in: 0...pacount)
                
                if photoArray.count != 0{
                    albumIcon.image = UIImage(contentsOfFile: photoArray[randomInt])
                }
                
                
                collectionView.reloadData()
               
            }
            alert.addAction(action)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] action, indexPath in
            
            
            let alert = UIAlertController(title: "Are you sure you want to delete \(albumArray[indexPath.row])?", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
             
                albumArray.remove(at: indexPath.row)
                self.defaults.set(self.albumArray, forKey: "AlbumsArray")
                defaults.removeObject(forKey: album)
                defaults.removeObject(forKey: "commentsFor\(album)")
                collectionView.reloadData()
                if albumArray.count == 0{
                    middleLabel.text = "Add your first album"
                }
                else{
                    middleLabel.text = ""
                }
            }
            alert.addAction(action)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)

        }
        
//        let editAction = SwipeAction(style: .destructive, title: "Change Album Icon?") { [self] action, indexPath in
//
//            let photosVC = PhotosViewController()
//
//            let albumCell = collectionView.cellForItem(at: indexPath)
//
//
//            let albumIcon = albumCell?.viewWithTag(20) as! UIImageView
//
//            let photoArray = photosVC.photoArray
//
//            if photoArray.count > 0{
//                albumIcon.image = UIImage(contentsOfFile:photoArray[0])
//                print("THERE ARE PHOTOS IN THE ALBUM")
//            }
//            else if photoArray.count < 0{
//                print("THERE ARE NO PHOTOS IN THE ALBUM")
//            }
//            collectionView.reloadData()
//
//
//
//        }
        
        
        
        if orientation == .right{
            action = [deleteAction]
            
        }
        else if orientation == .left{
            action = [editAction]
        }
        
//        if orientation == .left{
//            action = [editAction]
//        }
        
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        

    return action
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }
}
class MenuController: UITableViewController{
    
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
        if menuItems[indexPath.row] == "Post"{
//            let collectionView = CollectionViewController()
//
//            collectionView.gridIsSelected = false
//            collectionView.collectionView.reloadData()
            print("Post option was selected")
        }
    }
}

extension CollectionViewController: DataManagingDelegate{
    func didUpdateData(_ dataManaging: DataManaging, data: DataModel) {
        DispatchQueue.main.async {
            self.albumArray.append(data.name)
            self.album = data.name
            self.defaults.set(self.albumArray, forKey: "AlbumsArray")
            self.defaults.set(nil, forKey: data.name)
            if self.albumArray.count == 0{
                self.middleLabel.text = "Add your first album"
            }
            else{
                self.middleLabel.text = ""
            }
            self.collectionView.reloadData()
            let photosVC = PhotosViewController()
            photosVC.album = data.name
            photosVC.comments.append(data.userEmail)
            let url = URL(string: data.avatarImage)!

                // Fetch Image Data
            if let datar = try? Foundation.Data(contentsOf: url) {
                    // Create Image and Update Image View
                let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                
                let theUrl = documents.appendingPathComponent("image\(photosVC.photoArray.count)\(self.album!).png")
                
                    let theImg = UIImage(data: datar)
                if let imgData = theImg!.pngData() {
                    do {
                        try imgData.write(to: theUrl)
                        
                        photosVC.photoArray.append(theUrl.path)
                        
                        photosVC.imageID = url.path
                        
                        //Deprecated
                        self.defaults.set(photosVC.photoArray, forKey: self.album)
                         
//                        self.collectionView.reloadData()
                        
                        print(theUrl)
                    }
                    catch{
                        
                    }
                }
                       
                
                }
            
            self.defaults.set(photosVC.comments, forKey: "commentsFor" + self.album)
            self.defaults.set(photosVC.photoArray, forKey: data.name)
        }
    }
    
    func didFailWithError(error: Error) {
        print("THE ERROR IS: \(error)")
    }
    
    
}
