//
//  AfterSignUpController.swift
//  ShareYourMoment
//
//  Created by TPPFIT iCloud on 8/8/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit
import Firebase

class AfterSignUpController: UIViewController,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet var btnEdit: UIButton!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtAddress: UITextField!
    @IBOutlet var txtPhone: UITextField!
    @IBOutlet var txtAbout: UITextField!
    @IBOutlet var imgAvatar: UIImageView!
    
    @IBOutlet var viewContain: UIView!
    var email:String!
    var userUID:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        txtName.delegate = self
        txtAddress.delegate = self
        txtPhone.delegate = self
        txtAbout.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        btnEdit.layer.cornerRadius = 25
        imgAvatar.layer.cornerRadius = 75
        btnEdit.setImage(btnEdit.currentImage?.tint(with: UIColor.black), for: .normal)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func clickOnButtonEdit(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("finish")
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        dismiss(animated: true, completion: nil)
        self.imgAvatar.image = chosenImage
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
                self.viewContain.transform = CGAffineTransform(translationX: 0, y:  -200)
            })
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        UIView.animate(withDuration: 0.5, animations: {
            self.viewContain.transform = .identity
        })
    }
    @IBAction func clickOnButtonSave(_ sender: Any) {
        if txtName.text == "" || txtAbout.text == "" || txtPhone.text == "" || txtAddress.text == "" {
            print("nil")
            
        }else{
            print("set value")
            var ref:FIRDatabaseReference!
            ref = FIRDatabase.database().reference()
            
            ref.child("users").child(userUID!).setValue(["Name":txtName.text!,"Phone":txtPhone.text!,"Address":txtAddress.text!,"Email":email,"About":txtAbout.text!,"Image":"man"])
            
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewFeedController") as! NewFeedController
            
        }
        
    }
    

}
