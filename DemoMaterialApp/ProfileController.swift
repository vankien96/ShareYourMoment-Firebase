//
//  ProfileController.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/3/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileController: UIViewController {

    @IBOutlet var btnSave: UIButton!
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtPhone: UITextField!
    
    
    var userInfo:Member!
    
    @IBOutlet var viewInfo: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        self.enableEdit(false)
        let useruid = FIRAuth.auth()?.currentUser?.uid
        GetMemberData.getProfile(userUID: useruid!) { (userInfo) in
            self.userInfo = userInfo
            self.setDataToview()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        btnBack.setImage(UIImage(named: "icon_backspace")?.tint(with: UIColor.white), for: .normal)
        btnSave.layer.cornerRadius = 10
        
        viewInfo.layer.borderWidth = 1.0
        viewInfo.layer.borderColor = UIColor.clear.cgColor
        viewInfo.layer.masksToBounds = true
        viewInfo.layer.shadowColor = UIColor.gray.cgColor
        viewInfo.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        viewInfo.layer.shadowRadius = 5.0
        viewInfo.layer.shadowOpacity = 1.0
        viewInfo.layer.masksToBounds = false
        imgAvatar.clipsToBounds = true
        imgAvatar.layer.cornerRadius = 40
        
    }
    func setDataToview() {
        if userInfo != nil {
            DispatchQueue.global(qos: .userInitiated).async {
                let url = URL(string: self.userInfo.image)
                if let data:Data = try? Data(contentsOf: url!) {
                    DispatchQueue.main.async {
                        UIView.transition(with: self.imgAvatar, duration: 0.5, options: .transitionCrossDissolve, animations: { 
                            self.imgAvatar.image = UIImage(data: data)
                        }, completion: nil)
                    }
                }
            }
            txtName.text = userInfo.name
            txtAddress.text = userInfo.address
            txtEmail.text = userInfo.email
            txtPhone.text = userInfo.phoneNumber
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    @IBAction func clickOnButtonBack(_ sender: Any) {
        
        
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    @IBAction func clickOnButtonEdit(_ sender: Any) {
        self.enableEdit(true)
        txtName.becomeFirstResponder()
    }

    @IBAction func clickOnButtonSaveButton(_ sender: Any) {
        self.enableEdit(false)
    }
    
    func enableEdit(_ edit:Bool){
        txtName.isUserInteractionEnabled = edit
        txtAddress.isUserInteractionEnabled = edit
        txtPhone.isUserInteractionEnabled = edit
        txtEmail.isUserInteractionEnabled = edit
        
    }

}
