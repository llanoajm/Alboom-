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
    let refreshControl = UIRefreshControl()
    
    private let sideMenu = SideMenuNavigationController(rootViewController: MenuController(with: ["Display Options", "Grid", "Post"] ))
//    var deletingHidden = false
    
    @IBOutlet weak var sideBarBurger: UIBarButtonItem!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var albumIcon: UIImageView!
    
    @IBOutlet weak var middleLabel: UILabel!
    
    @IBOutlet weak var txtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
//        activityIndicator.isHidden = true
        dataManaging.delegate = self
        
        
        sideMenu.leftSide = true
        SideMenuManager.default.leftMenuNavigationController = sideMenu
        SideMenuManager.default.addPanGestureToPresent(toView: view)
        
        //Setting albumsArray to equal the array in UserDefaults.
        if let items = (defaults.array(forKey: "AlbumsArray") as? [String]){
            albumArray = items
            
        }
            if albumArray.contains("Janet") && albumArray.contains("George") && albumArray.contains("Emma") && albumArray.contains("Eve") && albumArray.contains("Charles") && albumArray.contains("Tracey"){
                print("IT DOES")
            }
            else{
                dataManaging.fetchData()
                
            }
//            dataManaging.fetchData()

        
        
        if albumArray.count == 0{
            middleLabel.text = "Add your first album"
        }
        else{
            middleLabel.text = ""
        }
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.backgroundColor = nil
       
           refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
           collectionView.addSubview(refreshControl)
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! SwipeCollectionViewCell
        
        albumCell.delegate = self
        
        album = albumArray[indexPath.row]
        
        let albumIcon = albumCell.viewWithTag(20) as! UIImageView
        
        var photoArray = ["String"]
        
        if let items = (defaults.array(forKey: album) as? [String]){
        photoArray = items}
        
//        let pacount = photoArray.count - 1
//
//        let randomInt = Int.random(in: 0...pacount)
        
        if photoArray.count != 0{
            albumIcon.image = UIImage(contentsOfFile: photoArray[0])
        }
        if photoArray == ["String"]{
            albumIcon.image = UIImage(named: "default-image")
        }
        
        
        
        
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
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
        else if gridIsSelected == false{
            
        }
        
        albumCell.layer.cornerRadius = 15.0
        albumCell.layer.borderWidth = 5.0
        albumCell.layer.borderColor = UIColor.clear.cgColor
        albumCell.layer.masksToBounds = true

             // cell shadow section
        albumCell.contentView.layer.cornerRadius = 15.0
        albumCell.contentView.layer.borderWidth = 5.0
        albumCell.contentView.layer.borderColor = UIColor.clear.cgColor
        albumCell.contentView.layer.masksToBounds = true
        albumCell.layer.shadowColor = UIColor.gray.cgColor
        albumCell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        albumCell.layer.shadowRadius = 6.0
        albumCell.layer.shadowOpacity = 0.6
        albumCell.layer.cornerRadius = 15.0
        albumCell.layer.masksToBounds = false
        albumCell.layer.shadowPath = UIBezierPath(roundedRect: albumCell.bounds, cornerRadius: albumCell.contentView.layer.cornerRadius).cgPath
        
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
        refreshControl.isHidden = true
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

extension CollectionViewController: DataManagingDelegate{
    func didUpdateData(_ dataManaging: DataManaging, data: DataModel) {
        DispatchQueue.main.async {
            
//            self.activityIndicator.isHidden = false
//            self.activityIndicator.startAnimating()
            
            for num in 1...(data.userEmails.count - 1){
                self.albumArray.append(data.first_names[num])
                self.album = data.first_names[num]
                self.defaults.set(self.albumArray, forKey: "AlbumsArray")
                self.defaults.set(nil, forKey: data.first_names[num])
                if self.albumArray.count == 0{
                    self.middleLabel.text = "Add your first album"
                }
                else{
                    self.middleLabel.text = ""
                }
                self.collectionView.reloadData()
                let photosVC = PhotosViewController()
                photosVC.album = data.first_names[num]
                photosVC.comments.append(data.userEmails[num])
                let url = URL(string: data.avatarImages[num])!
                if let datar = try? Foundation.Data(contentsOf: url) {
                    
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
                    self.defaults.set(photosVC.comments, forKey: "commentsFor" + self.album)
                    self.defaults.set(photosVC.photoArray, forKey: data.first_names[num])
                    
                }
            }
            

        }
//        activityIndicator.stopAnimating()
//        activityIndicator.isHidden = true
    }
    
    func didFailWithError(error: Error) {
        let alert = UIAlertController(title: "You are probably offline", message: "Connect to the internet to load images", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        print("THE ERROR IS: \(error)")
    }
    
    
}


