//
//  WelcomeController.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/1/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit
import Firebase
import SystemConfiguration

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
class WelcomeController: UIViewController,UITextFieldDelegate {

    @IBOutlet var imgLogo: UIImageView!
    @IBOutlet var lb1: UILabel!
    @IBOutlet var lb2: UILabel!
    @IBOutlet var txtDetail: UITextView!
    @IBOutlet var viewButton: UIView!
    
    @IBOutlet var viewSignIn: UIView!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var txtPassword: UITextField!
    @IBOutlet var btnSignIn: UIButton!
    
    @IBOutlet var viewBack: UIView!
    @IBOutlet var imgBack: UIImageView!
    
    @IBOutlet var viewSignUp: UIView!
    @IBOutlet var txtEmailSignUp: UITextField!
    @IBOutlet var txtPasswordSignUp: UITextField!
    @IBOutlet var txtPasswordAgain: UITextField!
    @IBOutlet var btnSignUp: UIButton!
    
    
    var checkSignInOrUp:Int = 0
    var userDefaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        txtUsername.delegate = self
        txtPassword.delegate = self
        if userDefaults.string(forKey: "USERID") != ""{
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewFeedController") as! NewFeedController
            
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.prepareScreen()
    }
    
    func prepareScreen(){
        viewBack.layer.cornerRadius = 20
        imgBack.image = imgBack.image?.tint(with: UIColor(red: 219/255.0, green: 123/255.0, blue: 104/255.0, alpha: 1))
        
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.viewBack.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.viewSignIn.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            self.viewSignUp.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.lb1.transform = .identity
            self.lb2.transform = .identity
            self.txtDetail.transform = .identity
            self.viewButton.transform = .identity
        }, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 1 {
            txtPassword.becomeFirstResponder()
        }else{
            
        }
        return false
    }
    
    
//---------------------------------------------------------------------//
//                              ANIMATION                              //
// --------------------------------------------------------------------//
    
    @IBAction func clickOnButtonShowDialogSignIn(_ sender: Any) {
        checkSignInOrUp = 1
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.viewButton.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.lb1.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            self.lb2.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            self.txtDetail.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.viewSignIn.transform = .identity
            self.viewBack.transform = .identity
        }, completion: nil)
    }
    @IBAction func clickOnButtonShowDialogSignUp(_ sender: Any) {
        checkSignInOrUp = 2
        UIView.animate(withDuration: 2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.viewButton.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.lb1.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            self.lb2.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
            self.txtDetail.transform = CGAffineTransform(translationX: 0, y: -self.view.frame.height)
        }, completion: nil)
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.imgLogo.transform = CGAffineTransform(translationX: 0, y: -10)
            self.viewSignUp.transform = .identity
            self.viewBack.transform = .identity
        }, completion: nil)
        
    }

    @IBAction func clickOnButtonBack(_ sender: Any) {
        if checkSignInOrUp == 1{
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                self.viewSignIn.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
                self.lb1.transform = .identity
                self.lb2.transform = .identity
                self.txtDetail.transform = .identity
                self.viewButton.transform = .identity
                self.viewBack.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }, completion: nil)
        }else{
            UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                self.imgLogo.transform = .identity
                self.viewSignUp.transform = CGAffineTransform(translationX: self.view.frame.width, y: 0)
                self.lb1.transform = .identity
                self.lb2.transform = .identity
                self.txtDetail.transform = .identity
                self.viewButton.transform = .identity
                self.viewBack.transform = CGAffineTransform(translationX: -self.view.frame.width, y: 0)
            }, completion: nil)
        }
    }
//---------------------------------------------------------------------//
//                            END ANIMATION                            //
// --------------------------------------------------------------------//
    
    @IBAction func clickOnButtonSignIn(_ sender: Any) {
        if txtUsername.text == "" || txtPassword.text == ""{
            let alert:UIAlertController = UIAlertController(title: "Warning", message: "Username and Password can not empty", preferredStyle: .alert)
            let action:UIAlertAction = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }else{
            if self.connectedToNetwork(){
                FIRAuth.auth()?.signIn(withEmail: txtUsername.text!, password: txtPassword.text!, completion: { (user, error) in
                    if error == nil {
                        print((user?.uid)!)
                        self.userDefaults.setValue("002", forKey: "USERID")
                        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewFeedController") as! NewFeedController
                        
                        self.navigationController?.pushViewController(controller, animated: true)
                    }else{
                        print("Have some error")
                        let alert = UIAlertController(title: "Signin Failed", message: "Your username or password is wrong", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    }
                })
            }else{
                let alert = UIAlertController(title: "Connection", message: "Please check your connection", preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func clickOnButtonSignUp(_ sender: Any) {
        if self.connectedToNetwork() {
            FIRAuth.auth()?.createUser(withEmail: txtEmailSignUp.text!, password: txtPasswordSignUp.text!, completion: { (user, error) in
                if error != nil {
                    print("Have some error \(error?.localizedDescription)")
                    let alert = UIAlertController(title: "Failed", message: "\((error?.localizedDescription)!)", preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: nil)
                    })
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }else{
                    print("Sign up success")
                    let controller = self.storyboard?.instantiateViewController(withIdentifier: "AfterSignUpController") as! AfterSignUpController
                    controller.userUID = user?.uid
                    controller.email = self.txtEmailSignUp.text!
                    self.navigationController?.pushViewController(controller, animated: true)
                }
            })
        }else{
            let alert = UIAlertController(title: "Connection", message: "Please check your connection", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
    }
}




//EXTENSION
extension UIImage {
    func tint(with color: UIColor) -> UIImage {
        var image = withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        color.set()
        
        image.draw(in: CGRect(origin: .zero, size: size))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
