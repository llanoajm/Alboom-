//
//  PhotosViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 20/10/20.
//

import UIKit
import SwipeCellKit
import UnsplashPhotoPicker

class PhotosViewController: UICollectionViewController {
    
    
    
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 20.0
    private var fillColor: UIColor = .blue
    
    let configuration = UnsplashPhotoPickerConfiguration(
      accessKey: "NzKpTgzqy1-1fihxXYksBEyTzm7YMqrryq_MtGCNYS4",
      secretKey: "UsY8V4uaiCrdQXXhjX8QnT36g_gF6OoX5M86Ac3ixhg"
    )
    
    let containerView = UIView()
    
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
    var dataManaging = DataManaging()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        dataManaging.delegate = self
        
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        header.title = album
        
        
        //Deprecating
        if let items = (defaults.array(forKey: album) as? [String]){
        photoArray = items}
        
        //Deprecating
        if let itemsTwo = (defaults.array(forKey: commentKey) as? [String]){
        comments = itemsTwo
         }
        if photoArray.count == 0{
            middleLabel.text = "Add your first photo"
        }
        else{
            middleLabel.text = ""
        }
        //Looks for single or multiple taps.
//         let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

//        view.addGestureRecognizer(tap)

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print(comments)
        
        
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
        if comments[indexPath.row].count != 0{
            label.text = comments[indexPath.row]
        }
            
        
            
            let imgView = photoCell.viewWithTag(3) as! UIImageView
            
        //Deprecated
        
        imgView.image = UIImage(contentsOfFile: photoArray[indexPath.row])
        
                    
        let txtField = photoCell.viewWithTag(4) as! UITextField
        txtField.delegate = self
        
        txtField.text = comments[indexPath.row]
        
            
        
        for num in 0...photoArray.count{
            let photoNumber = String(num)
           
            if txtField.text == "New Photo " + photoNumber{
                
                label.alpha = 0
            }
            else if txtField.text != "New Photo " + String(num){
                label.alpha = 1
            }
        }
        
        presentIndexPathRow = indexPath.row
        

        

        photoCell.layer.cornerRadius = 15.0
photoCell.layer.borderWidth = 5.0
        photoCell.layer.borderColor = UIColor.clear.cgColor
        photoCell.layer.masksToBounds = true

             // cell shadow section
        photoCell.contentView.layer.cornerRadius = 15.0
        photoCell.contentView.layer.borderWidth = 5.0
        photoCell.contentView.layer.borderColor = UIColor.clear.cgColor
       photoCell.contentView.layer.masksToBounds = true
        photoCell.layer.shadowColor = UIColor.gray.cgColor
             photoCell.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        photoCell.layer.shadowRadius = 6.0
        photoCell.layer.shadowOpacity = 0.6
        photoCell.layer.cornerRadius = 15.0
        photoCell.layer.masksToBounds = false
        photoCell.layer.shadowPath = UIBezierPath(roundedRect: photoCell.bounds, cornerRadius: photoCell.contentView.layer.cornerRadius).cgPath


            return photoCell
        }

    
    @IBAction func addPhotoPressed(_ sender: UIBarButtonItem) {
       
        
        let vc = UIImagePickerController()
        
        let photoPicker = UnsplashPhotoPicker(configuration: configuration)
        photoPicker.photoPickerDelegate = self
        
        
        
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        let alert = UIAlertController(title: "Where do you want to select your photos from?", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Library", style: .default) { (action) in
            
            self.present(vc, animated: true)
        }
        let otherAction = UIAlertAction(title: "Unsplash", style: .default) { (action) in
            self.present(photoPicker, animated: true, completion: nil)
        }
        alert.addAction(action)
        alert.addAction(otherAction)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
    
    
}
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

extension PhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let collectView = CollectionViewController()
        comments.append("New Photo \((comments.count+1))")
//        comments.append("")
        
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
//        collectView.collectionView.reloadData()
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

extension PhotosViewController: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.alpha = 0.5
        
        textField.selectAll(nil)
        
        
        activeComment = textField.text!
        print(activeComment!)
        

        
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        textField.alpha = 0.1
        
        //prone to errors
        //Deprecated
        
        
//        print("THE INDEXPATH.ROW IS \(indexPath.row)")
        
        
        presentIndexPathRow = comments.firstIndex(of: activeComment)
        
//        print("The index Path Row is : \(presentIndexPathRow!)")
        
        
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
extension PhotosViewController: UnsplashPhotoPickerDelegate{
    func unsplashPhotoPicker(_ photoPicker: UnsplashPhotoPicker, didSelectPhotos photos: [UnsplashPhoto]) {
        comments.append("New Photo \((comments.count+1))")
        
//        comments.append("")
        
        
        
    }
    
    func unsplashPhotoPickerDidCancel(_ photoPicker: UnsplashPhotoPicker) {
        photoPicker.dismiss(animated: true, completion: nil)
    }
    
    
}



extension PhotosViewController: DataManagingDelegate{
    func didUpdateData(_ dataManaging: DataManaging, data: DataModel) {
        
    }
    
    func didFailWithError(error: Error) {
        
    }
    
    
}
