//
//  NewViewController.swift
//  albumapp
//
//  Created by Antonio Llano on 6/11/20.
//

import UIKit

class NewViewController: UIViewController {

    var image: String!
    var photoComment: String!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var photoDescription: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = UIImage(contentsOfFile: image)
        photoDescription.text = photoComment
    
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
