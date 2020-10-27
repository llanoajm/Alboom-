//
//  PhotosViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 20/10/20.
//

import UIKit

class PhotosViewController: UICollectionViewController {
    
    //bottom were edits
    var album: String!
    let defaults = UserDefaults.standard
//    var photoArray: [String] = []
    var photoArray: [String] = []
   // var photoArray: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let items = (defaults.array(forKey: album) as? [String]){
        photoArray = items}

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = UICollectionViewCell()

        if let photoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell{
            print("the file is: \(photoArray[indexPath.row])")
            //photoCell.configure(with: photoArray[indexPath.row])
            photoCell.configure(with: UIImage(contentsOfFile: photoArray[indexPath.row])!)
            //replace previous
            cell = photoCell
        }


        return cell
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
                   print(photoArray.count)
                    print("Task Failed Succesfully")
                    
                    
                   self.defaults.set(self.photoArray, forKey: album)
//                    defaults.set(url, forKey: album)
                     
                    self.collectionView.reloadData()
                     
                 } catch let error as NSError{
                    NSLog("%@", error.description)
                     print("Unable to Write Image Data to Disk")
                    do{
                        photoArray.append(try String(contentsOf: url))
                    }
                    catch{
                        print("there was an error appending the url")
                    }
                   
                     defaults.set(photoArray, forKey: album)
                    
                    
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
