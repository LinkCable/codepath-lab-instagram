//
//  PhotoDetailsViewController.swift
//  Moment
//
//  Created by Philippe Kimura-Thollander on 2/11/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit
import AFNetworking

class PhotoDetailsViewController: UIViewController {

    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    var photo: NSDictionary!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let imageUrl = NSURL( string: photo.valueForKeyPath("images.standard_resolution.url") as! String)
        photoView.setImageWithURL(imageUrl!)
        
        profileLabel.textColor = UIColor(red:33/255.0, green:146/255.0, blue:255/255.0, alpha: 1.0)
        profileLabel.text = photo.valueForKeyPath("user.username") as? String
        
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 15
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).CGColor
        profileView.layer.borderWidth = 1
        
        let profilePictureUrl = NSURL(string: photo.valueForKeyPath("user.profile_picture") as! String)
        profileView.setImageWithURL(profilePictureUrl!)
        
        captionLabel.text = photo.valueForKeyPath("caption.text") as? String
        
        likesLabel.textColor = UIColor(red:33/255.0, green:146/255.0, blue:255/255.0, alpha: 1.0)
        likesLabel.text = String(photo.valueForKeyPath("likes.count") as! Int)
        
        likesLabel.text! += " likes"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
