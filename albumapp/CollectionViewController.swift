//
//  CollectionViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 20/10/20.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    var album = ""
    var albumArray:[String] = ["Familia", "Viajes", "Yosemite", "Mojave"]
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Setting albumsArray to equal the array in UserDefaults.
        if let items = (defaults.array(forKey: "AlbumsArray") as? [String]){
            albumArray = items
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albumArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()
        
        if let albumCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCell", for: indexPath) as? AlbumCell{
            albumCell.configure(with: albumArray[indexPath.row])
            cell = albumCell
        }
        
        
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Selected \(albumArray[indexPath.row])")
        album = albumArray[indexPath.row]
        
        performSegue(withIdentifier: "AlbumToPhoto", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AlbumToPhoto"{
            let photoVC = segue.destination as! PhotosViewController
            photoVC.album = self.album
            print(album)
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
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add a title to your album"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
        
    }
    
    

}
