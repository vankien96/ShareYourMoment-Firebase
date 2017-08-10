//
//  NewFeedViewCell.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/2/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit

class NewFeedViewCell: UICollectionViewCell {

    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbTime: UILabel!
    @IBOutlet var imgmain: UIImageView!
    @IBOutlet var Status: UITextView!
    @IBOutlet var btnMemberDetail: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgAvatar.layer.cornerRadius = 20.0
        imgAvatar.clipsToBounds = true
    }
}
