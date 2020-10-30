//
//  PhotoCell.swift
//  albumapp
//
//  Created by Antonio Llano on 21/10/20.
//

import UIKit

class PhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var txtField: UITextField!
    
    @IBOutlet private weak var ImgView: UIImageView!
    
    @IBOutlet weak var textLabel: UILabel!
    
    func configure(with photo: UIImage){
        ImgView.image = photo
        //print(photo)
    }
    func configureText(with text: String){
        textLabel.text = text
    }
 
}
