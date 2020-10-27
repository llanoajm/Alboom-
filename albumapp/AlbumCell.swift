//
//  AlbumCell.swift
//  albumapp
//
//  Created by Antonio Llano on 20/10/20.
//

import UIKit

class AlbumCell: UICollectionViewCell {
    
    @IBOutlet private weak var albumLabel: UILabel!
    
    func configure(with albumName: String){
        albumLabel.text = albumName
        print(albumName)
       
    }
}
