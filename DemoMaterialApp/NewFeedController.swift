//
//  NewFeedController.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/2/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit
import Firebase

class NewFeedController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{

    
    @IBOutlet var viewButtonBack: UIView!
    @IBOutlet var lbName: UILabel!
    @IBOutlet var imgAvatar: UIImageView!
    
    
    @IBOutlet var viewContainNewFeed: UIView!
    @IBOutlet var btnMenu: UIButton!
    @IBOutlet var newFeedCollection: UICollectionView!
    @IBOutlet var viewCollection: UIView!
    
    @IBOutlet var imgAdd: UIImageView!
    @IBOutlet var viewButtonAdd: UIView!
    
    
    
    var statusData:[AStatus] = [AStatus]()
    var memberData:[Member] = [Member]()
    var userInfo:Member!
    
    var originalSizeOfCell:CGRect!
    var indexPath:IndexPath!
    override func viewDidLoad() {
        super.viewDidLoad()
        newFeedCollection.dataSource = self
        newFeedCollection.delegate = self
        let nib = UINib(nibName: "NewFeedViewCell", bundle: nil)
        newFeedCollection.register(nib, forCellWithReuseIdentifier: "newFeedViewCell")
        
        //get data
        GetMemberData.getMemberData(completion:{ (user) in
            if user.count != 0{
                self.memberData = user
            }
        })
        print(UserDefaults.standard.string(forKey: "USERID")!)
        GetMemberData.getProfile(userUID: UserDefaults.standard.string(forKey: "USERID")!) { (user) in
            self.userInfo = user
            self.lbName.text = self.userInfo.name
            DispatchQueue.global(qos: .userInitiated).async {
                let data = try? Data(contentsOf: URL(string: self.userInfo.image)!)
                DispatchQueue.main.async {
                    self.imgAvatar.image = UIImage(data: data!)
                }
            }
        }
        GetStatusData.getStatusData { (statusData) in
            self.statusData = statusData
            DispatchQueue.main.async {
                self.newFeedCollection.reloadData()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        imgAvatar.layer.cornerRadius = 20.0
        imgAvatar.clipsToBounds = true
        imgAdd.image = imgAdd.image?.tint(with: UIColor.white)
        viewButtonAdd.layer.cornerRadius = 25
        viewButtonBack.layer.cornerRadius = 20
        viewContainNewFeed.transform = .identity
        
        self.viewButtonAdd.isUserInteractionEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newFeedViewCell", for: indexPath) as! NewFeedViewCell
        
        let member = foundMember(statusData[indexPath.item].idMember)
        cell.imgmain.image = UIImage()
        DispatchQueue.global(qos: .userInitiated).async {
            let dataAvatar = try? Data(contentsOf: URL(string: member.image)!)
            DispatchQueue.main.async {
                UIView.transition(with: cell.imgmain, duration: 0.4, options: .transitionCrossDissolve, animations: {
                    cell.imgAvatar.image = UIImage(data: dataAvatar!)
                    cell.imgmain.image = self.statusData[indexPath.row].image
                }, completion: nil)
            }
        }
        cell.lbName.text = member.name
        cell.lbTime.text = statusData[indexPath.item].time
        cell.Status.text = statusData[indexPath.item].status
        
        //Get index of member in memberData
        if let index = memberData.index(where: { (item:Member) -> Bool in
            item.idMember == member.idMember
        }){
            cell.btnMemberDetail.tag = index
        }
        
        cell.btnMemberDetail.addTarget(self, action: #selector(clickOnMoreDetailMember(_:)), for: .touchUpInside)
        
        // set shadow around the Cell
//        cell.contentView.layer.cornerRadius = 10
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cell.layer.shadowRadius = 2.0
        cell.layer.shadowOpacity = 1.0
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    func clickOnMoreDetailMember(_ sender:UIButton){
        let index = sender.tag
        let member = memberData[index]
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "MemberDetailController") as! MemberDetailController
        controller.userInfo = member
        self.navigationController?.pushViewController(controller, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width - 2, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? NewFeedViewCell{
            originalSizeOfCell = cell.frame
            self.indexPath = indexPath
            UIView.animate(withDuration: 0.5, animations: {
                cell.frame = collectionView.bounds
                self.view.layoutIfNeeded()
            })
            UIView.transition(with: btnMenu, duration: 0.5, options: .transitionCrossDissolve, animations: { 
                let image = UIImage(named: "icon_backspace")
                self.btnMenu.setImage(image?.tint(with: UIColor.white), for: .normal)
            }, completion: nil)
            cell.superview?.bringSubview(toFront: cell)
            collectionView.isScrollEnabled = false
            collectionView.isUserInteractionEnabled = false
        }
        
    }
    
    func foundMember(_ idMember:String) -> Member{
        for member in memberData {
            if member.idMember == idMember{
                return member
            }
        }
        return Member()
    }
    @IBAction func clickOnButtonMenu(_ sender: Any) {
        let image = UIImage(named: "Menu")
        if btnMenu.currentImage != image{
            print("Back")
            if let cell = newFeedCollection.cellForItem(at: indexPath) as? NewFeedViewCell{
                UIView.animate(withDuration: 0.5, animations: {
                    cell.frame = self.originalSizeOfCell
                    self.view.layoutIfNeeded()
                })
                UIView.transition(with: btnMenu, duration: 0.5, options: .transitionCrossDissolve, animations: {
                    let image = UIImage(named: "Menu")
                    self.btnMenu.setImage(image, for: .normal)
                }, completion: nil)
                newFeedCollection.isScrollEnabled = true
                newFeedCollection.isUserInteractionEnabled = true
            }
            
        }else{
            print("Menu")
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
                
                self.viewContainNewFeed.transform = CGAffineTransform(translationX: self.view.frame.width/3, y: 10).scaledBy(x: 0.8, y: 0.8)
                self.viewContainNewFeed.isUserInteractionEnabled = false
                
            }, completion: nil)
        }
    }
    @IBAction func clickOnButtonBack(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [], animations: {
            self.viewContainNewFeed.transform = .identity
            self.viewContainNewFeed.isUserInteractionEnabled = true
        }, completion: nil)
    }
    @IBAction func clickOnButtonLogOut(_ sender: Any) {
        do {
            try FIRAuth.auth()?.signOut()
            UserDefaults.standard.setValue("", forKey: "USERID")
            self.navigationController?.popToRootViewController(animated: true)
        }catch{
            print("error")
        }
    }
    
    @IBAction func clickOnButtonListFriend(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ListFriendController") as! ListFriendController
        controller.friendData = memberData
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    @IBAction func clickOnButtonProfile(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "ProfileController") as! ProfileController
        controller.userInfo = userInfo
        self.navigationController?.pushViewController(controller, animated: true)
        
    }

    
    @IBAction func clickOnButtonAddNewStatus(_ sender: Any) {
        let controller = self.storyboard?.instantiateViewController(withIdentifier: "NewStatusController") as! NewStatusController
        controller.userInfo = userInfo
        self.viewButtonAdd.isUserInteractionEnabled = false
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    
    
    
    
    func resizeImage(with image: UIImage) -> UIImage {
        let newSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*image.size.height)/image.size.width)
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
}
