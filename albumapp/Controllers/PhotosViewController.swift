//
//  PhotosViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 20/10/20.
//

import UIKit
import SwipeCellKit

class PhotosViewController: UICollectionViewController {
    
    
    @IBOutlet weak var header: UINavigationItem!
    @IBOutlet weak var middleLabel: UILabel!
    
    var album: String!
    let defaults = UserDefaults.standard
    
    //Deprecated
    var activeComment: String!
    var photoArray: [String] = []
    var imageID: String = ""
    var comments: [String] = []
    var commentsArray: [String] = []
    var commentKey: String!
    var presentIndexPathRow: Int!
    
    var photoItems = [PhotoItem]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        header.title = album
        
        
        //Deprecated
        if let items = (defaults.array(forKey: album) as? [String]){
        photoArray = items}
        
        //Deprecated
        if let itemsTwo = (defaults.array(forKey: commentKey) as? [String]){
        comments = itemsTwo
         }
        if photoArray.count == 0{
            middleLabel.text = "Add your first photo"
        }
        else{
            middleLabel.text = ""
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(comments)
        
        print("selectedPhoto")
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let secondVC = storyboard?.instantiateViewController(identifier: "ScrollCollection")as! ScrollCollection
        
        //Deprecated
        secondVC.photos = photoArray
        secondVC.photoComments = comments
        secondVC.selectedIndexPath = indexPath
        
        self.navigationController?.pushViewController(secondVC, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        print("cell was created")
            let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! SwipeCollectionViewCell
                
            photoCell.delegate = self
            
            let label = photoCell.viewWithTag(2) as! UILabel
            
        //Deprecated
            label.text = comments[indexPath.row]
            
            let imgView = photoCell.viewWithTag(3) as! UIImageView
            
        //Deprecated
            imgView.image = UIImage(contentsOfFile: photoArray[indexPath.row])!
        
        let txtField = photoCell.viewWithTag(4) as! UITextField
        txtField.delegate = self
        
        txtField.text = comments[indexPath.row]
        txtField.alpha = 0.2
        
        presentIndexPathRow = indexPath.row
        
//        if comments[indexPath.row] == "New Photo \(Int())"{
//            label.alpha = 0
//        }
//        else{label.alpha = 1}
        
            
            
    //            photoCell.txtField.delegate = self
            


            return photoCell
        }

    
    @IBAction func addPhotoPressed(_ sender: UIBarButtonItem) {
       
        
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    
    
}
    
}

extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        //Deprecated
        comments.append("New Photo \((comments.count+1))")
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage{
           // photoArray.append(image)//deprecated*
            //edits here
            
             let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            
             // Create URL
            let url = documents.appendingPathComponent("image\(photoArray.count)\(album!).png")
           
            
             // Convert to Data
             if let data = image.pngData() {
                 do {
                     try data.write(to: url)
                     
                     print(url)
                    
                    //Deprecated
                    photoArray.append(url.path)
                    
                    imageID = url.path
                    
                    //Deprecated
                   self.defaults.set(self.photoArray, forKey: album)
                     
                    self.collectionView.reloadData()
                     
                 } catch let error as NSError{
                    NSLog("%@", error.description)
                     print("Unable to Write Image Data to Disk")
                    
                 }
             }
            
        }
        picker.dismiss(animated: true, completion: nil)
        
        if photoArray.count == 0{
            middleLabel.text = "Add your first photo"
        }
        else{
            middleLabel.text = ""
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PhotosViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.alpha = 1.0
        
        activeComment = textField.text!
        print(activeComment!)

        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //prone to errors
        //Deprecated
        
        
//        print("THE INDEXPATH.ROW IS \(indexPath.row)")
        
        
        presentIndexPathRow = comments.firstIndex(of: activeComment)
        
        print("The index Path Row is : \(presentIndexPathRow!)")
        
        
        comments.remove(at: presentIndexPathRow)
        comments.insert(textField.text!, at: (presentIndexPathRow))
        
        
        
        //Deprecated
        defaults.set(comments, forKey: commentKey)
        
        collectionView.reloadData()
        if textField.text != ""{
        textField.alpha = 0.2
        }
        
        
    }
    
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }

    
    
}

extension PhotosViewController: SwipeCollectionViewCellDelegate{
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { [self] action, indexPath in
            
            
            let alert = UIAlertController(title: "Are you sure you want to delete this photo?", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "Yes", style: .default) { (action) in
                //Deprecated
                photoArray.remove(at: indexPath.row)
                self.defaults.set(self.photoArray, forKey: album)
                
                //Deprecated
                comments.remove(at: indexPath.row)
                self.defaults.set(self.comments, forKey: "commentsFor\(String(describing: album))")
                collectionView.reloadData()
                if photoArray.count == 0{
                    middleLabel.text = "Add your first photo"
                }
                else{
                    middleLabel.text = ""
                }
            }
            alert.addAction(action)
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
            
    }
        
        
        deleteAction.image = UIImage(named: "delete-icon")

        return [deleteAction]
    
}
   
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        return options
    }

}



