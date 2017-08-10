//
//  NewStatusController.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/4/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit
import Firebase

class NewStatusController: UIViewController,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{

    @IBOutlet var viewTextView: UIView!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var imgAvatar: UIImageView!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var txtStatus: UITextView!
    @IBOutlet var imgStatus: UIImageView!
    var userInfo:Member!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtStatus.delegate = self
        self.hideKeyboardWhenTappedAround()
        txtStatus.text = "What's on your mind?"
    }
    override func viewWillAppear(_ animated: Bool) {
        btnBack.setImage(UIImage(named: "icon_backspace")?.tint(with: UIColor.white), for: .normal)
        imgAvatar.layer.cornerRadius = 20.0
        imgAvatar.clipsToBounds = true
        
        //set shadow
        viewTextView.layer.borderWidth = 1.0
        viewTextView.layer.borderColor = UIColor.clear.cgColor
        viewTextView.layer.masksToBounds = true
        viewTextView.layer.shadowColor = UIColor.gray.cgColor
        viewTextView.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        viewTextView.layer.shadowRadius = 5.0
        viewTextView.layer.shadowOpacity = 1.0
        viewTextView.layer.masksToBounds = false
        
        if userInfo != nil {
            lbName.text = userInfo.name
            DispatchQueue.global(qos: .userInitiated).async {
                if let data = try? Data(contentsOf: URL(string: self.userInfo.image)!){
                    DispatchQueue.main.async {
                        UIView.transition(with: self.imgAvatar, duration: 0.4, options: .transitionCrossDissolve, animations: {
                            self.imgAvatar.image = UIImage(data: data)
                        }, completion: nil)
                    }
                }
            }
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    @IBAction func clickOnButtonback(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("didBegin")
        UIView.transition(with: self.txtStatus, duration: 0.4, options: .transitionCrossDissolve, animations: {
            if self.txtStatus.text == "What's on your mind?"{
                self.txtStatus.text = ""
            }else{
                
            }
        }, completion: nil)
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtStatus.text == "" {
            UIView.transition(with: self.txtStatus, duration: 0.4, options: .transitionCrossDissolve, animations: { 
                self.txtStatus.text = "What's on your mind?"
            }, completion: nil)
        }
    }
    @IBAction func clickOnButtonChooseImage(_ sender: Any) {
        let alert = UIAlertController(title: "", message: "Choose your way to post an image", preferredStyle: .actionSheet)
        let actionLibrary = UIAlertAction(title: "Open Library", style: .default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .photoLibrary
            self.present(picker, animated: true, completion: nil)
        }
        let actionCamera = UIAlertAction(title: "Open Camera", style: .default) { (action) in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = false
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)
        }
        alert.addAction(actionLibrary)
        alert.addAction(actionCamera)
        self.present(alert, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("finish")
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        dismiss(animated: true, completion: nil)
        UIView.transition(with: self.imgStatus, duration: 0.4, options: .transitionCrossDissolve, animations: { 
            self.imgStatus.image = chosenImage
        }, completion: nil)
    }
    @IBAction func clickOnButtonPost(_ sender: Any) {
        if txtStatus.text == "What's on your mind?"||imgStatus.image == nil {
            let alert = UIAlertController(title: "Please", message: "Please write something or choose an image", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            let date = Date()
            let formater = DateFormatter()
            formater.dateFormat = "dd-MM-yyyy hh:mm:ss"
            let result = formater.string(from: date)
            print(result)
            let storageRef = FIRStorage.storage().reference().child("status").child("\(userInfo.idMember!)\(result).png")
            let imageData = UIImageJPEGRepresentation(imgStatus.image!, 1.0)
            let uploadTask = storageRef.put(imageData!, metadata: nil, completion: { (metadata, error) in
                if error != nil {
                    let alert = UIAlertController(title: "Failed", message: (error?.localizedDescription)!, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print((metadata?.downloadURL())!)
                    let databaseRef = FIRDatabase.database().reference().child("status").child("\(self.userInfo.idMember!)\(result)")
                    databaseRef.setValue(["Content":self.txtStatus.text!,"Image":"\((metadata?.downloadURL())!)","UserID":self.userInfo.idMember,"Time":result])
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
    }
}
