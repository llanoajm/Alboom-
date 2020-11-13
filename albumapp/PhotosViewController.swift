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
    
    var album: String!
    let defaults = UserDefaults.standard
    var photoArray: [String] = []
    var imageID: String = ""
//    var comment: String = ""
    var comments: [String] = []
    var commentsArray: [String] = []
    
    var commentKey: String!
    var presentIndexPathRow: Int!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10) 
        header.title = album
        
        if let items = (defaults.array(forKey: album) as? [String]){
        photoArray = items}
        
 
        
//        if let itemsTwo = (defaults.string(forKey: imageID)){
//            comment = itemsTwo
//        }
        
        if let itemsTwo = (defaults.array(forKey: commentKey) as? [String]){
        comments = itemsTwo
         }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("selectedPhoto")
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        
        let secondVC = storyboard?.instantiateViewController(identifier: "ScrollCollection")as! ScrollCollection
        
        secondVC.photos = photoArray
        secondVC.photoComments = comments
        self.navigationController?.pushViewController(secondVC, animated: true)
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
        print("cell was created")
            let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! SwipeCollectionViewCell
                
            photoCell.delegate = self
            
            let label = photoCell.viewWithTag(2) as! UILabel
            
            label.text = comments[indexPath.row]
            
            let imgView = photoCell.viewWithTag(3) as! UIImageView
            
            imgView.image = UIImage(contentsOfFile: photoArray[indexPath.row])!
        
        let txtField = photoCell.viewWithTag(4) as! UITextField
        txtField.delegate = self
        
        presentIndexPathRow = indexPath.row
        
            
            
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
        //Delete if bug
        comments.append("")
        
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
                    
                    photoArray.append(url.path)
                    
                    imageID = url.path
                    
                   print(photoArray.count)
                    
                    
                    
                   self.defaults.set(self.photoArray, forKey: album)
                     
                    self.collectionView.reloadData()
                     
                 } catch let error as NSError{
                    NSLog("%@", error.description)
                     print("Unable to Write Image Data to Disk")
                    
                 }
             }
             
            
            
            
            print(photoArray.count)
            //self.collectionView.reloadData()
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PhotosViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.alpha = 1.0
    }
    
//    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//        if textField.text != ""{
//            return true
//        }
//        else{
//            textField.placeholder = "Comment something"
//            return false
//        }
//    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if textField.text!.count > 2{
            return true
        }
        else{
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        //prone to errors
        comments.remove(at: presentIndexPathRow)
        comments.append(textField.text!)
        print("the imageID is \(imageID)")
//        defaults.set(comment, forKey: imageID)
        defaults.set(comments, forKey: commentKey)
        collectionView.reloadData()
        if textField.text != ""{
        textField.alpha = 0.2
        }
        textField.text = ""
        
        
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
            
            photoArray.remove(at: indexPath.row)
            self.defaults.set(self.photoArray, forKey: album)
            
            comments.remove(at: indexPath.row)
            self.defaults.set(self.comments, forKey: "commentsFor\(String(describing: album))")
//            collectionView.reloadData()
           
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


