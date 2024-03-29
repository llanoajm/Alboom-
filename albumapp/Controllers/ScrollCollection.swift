//
//  ScrollCollection.swift
//  albumapp
//
//  Created by Antonio Llano on 10/11/20.
//

import UIKit



class ScrollCollection: UICollectionViewController {
    
    
    
    var photos: [String]!
    var photoComments: [String]!
    var selectedIndexPath: IndexPath!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        pageControll.numberOfPages = photos.count
        
    
        print("View did load")
        print(photoComments)
        
//        let cellRect = c
//
        collectionView.scrollToItem(at: selectedIndexPath, at: .centeredHorizontally, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FullPhoto", for: indexPath)
        let imgView = cell.viewWithTag(9) as! UIImageView
        let label = cell.viewWithTag(10) as! UILabel
        imgView.image = UIImage(contentsOfFile: photos[indexPath.row])
        label.text = photoComments[indexPath.row]
        
    
        
    
        return cell
    }
    
    
}
extension ScrollCollection: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        pageControll.currentPage = indexPath.row
         let itemWidth = collectionView.bounds.width
         let itemHeight = collectionView.bounds.height
         return CGSize(width: itemWidth, height: itemHeight)
 }
}
