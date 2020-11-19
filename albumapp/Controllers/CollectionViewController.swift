//
//  CollectionViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 20/10/20.
//

import UIKit
import SwipeCellKit

class CollectionViewController: UICollectionViewController {
    var album = ""
    var albumArray:[String] = []
    let defaults = UserDefaults.standard
//    var deletingHidden = false
    
    
    @IBOutlet weak var albumIcon: UIImageView!
    
    @IBOutlet weak var middleLabel: UILabel!
    
    @IBOutlet weak var txtLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting albumsArray to equal the array in UserDefaults.
        if let items = (defaults.array(forKey: "AlbumsArray") as? [String]){
            albumArray = items
        }
        
        if albumArray.count == 0{
            middleLabel.text = "Add your first album"
        }
        else{
            middleLabel.text = ""
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as! SwipeCollectionViewCell
        
        albumCell.delegate = self
        
        let label = albumCell.viewWithTag(1) as! UILabel
        
        label.text = albumArray[indexPath.row]
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
    
    
    

}
extension CollectionViewController: SwipeCollectionViewCellDelegate{
    
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        var action = [SwipeAction]()
//        guard orientation == .right else { return nil }
        
        
        
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
