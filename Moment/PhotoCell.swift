//
//  PhotoCell.swift
//  Moment
//
//  Created by Philippe Kimura-Thollander on 2/3/16.
//  Copyright © 2016 Philippe Kimura-Thollander. All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    @IBOutlet weak var pictureView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
