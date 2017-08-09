//
//  ListFriendTableViewCell.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/4/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit

class ListFriendTableViewCell: UITableViewCell {

    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var lbAddress: UILabel!
    @IBOutlet var lbPhone: UILabel!
    @IBOutlet var lbEmail: UILabel!
    @IBOutlet var viewExpand: UIView!
    @IBOutlet var constraintHeight: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
