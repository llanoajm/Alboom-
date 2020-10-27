//
//  PhotoCell.swift
//  albumapp
//
//  Created by Antonio Llano on 21/10/20.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet private weak var ImgView: UIImageView!
    
    func configure(with photo: UIImage){
        ImgView.image = photo
        //print(photo)
    }
    
    
    
}
