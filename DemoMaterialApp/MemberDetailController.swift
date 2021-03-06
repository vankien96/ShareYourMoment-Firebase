//
//  MemberDetailController.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/3/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit

class MemberDetailController: UIViewController {

    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lbAddress: UILabel!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var viewAbout: UIView!
    @IBOutlet var txtAbout: UITextView!
    
    var userInfo:Member!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        imgAvatar.layer.cornerRadius = 60.0
        imgAvatar.clipsToBounds = true
        DispatchQueue.global(qos: .userInitiated).async {
            let data = try? Data(contentsOf: URL(string: self.userInfo.image)!)
            DispatchQueue.main.async {
                self.imgAvatar.image = UIImage(data: data!)
            }
        }
        lbName.text = userInfo.name
        lbAddress.text = userInfo.address
        txtAbout.text = userInfo.about
        
        btnBack.setImage(UIImage(named: "icon_backspace")?.tint(with: UIColor.white), for: .normal)
        
        //set shadow aroud view
        viewAbout.layer.borderWidth = 1.0
        viewAbout.layer.borderColor = UIColor.clear.cgColor
        viewAbout.layer.masksToBounds = true
        viewAbout.layer.shadowColor = UIColor.gray.cgColor
        viewAbout.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        viewAbout.layer.shadowRadius = 5.0
        viewAbout.layer.shadowOpacity = 1.0
        viewAbout.layer.masksToBounds = false
        //viewAbout.layer.shadowPath = UIBezierPath(roundedRect:viewAbout.bounds, cornerRadius:viewAbout.layer.cornerRadius).cgPath
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func clickOnButtonBack(_ sender: Any) {
        self.btnBack.isUserInteractionEnabled = false
        self.navigationController?.popViewController(animated: true)
    }

}
