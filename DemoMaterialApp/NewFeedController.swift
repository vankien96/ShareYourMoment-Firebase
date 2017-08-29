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

    let refresh = UIRefreshControl()
    
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
    
    var cacheImage = NSCache<NSString,UIImage>()
    
    @IBOutlet var loadingIcon: UIActivityIndicatorView!
    
    var originalSizeOfCell:CGRect!
    var indexPath:IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newFeedCollection.dataSource = self
        newFeedCollection.delegate = self
        
        
        //refresh controller
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        if #available(iOS 10.0, *) {
            newFeedCollection.refreshControl = refresh
        } else {
            // Fallback on earlier versions
            newFeedCollection.addSubview(refresh)
        }
        refresh.addTarget(self, action: #selector(self.reloadNewFeedData(_:)), for: .valueChanged)
        
        
        
        
        let nib = UINib(nibName: "NewFeedViewCell", bundle: nil)
        newFeedCollection.register(nib, forCellWithReuseIdentifier: "newFeedViewCell")
        loadingIcon.startAnimating()
        //get data
        GetMemberData.getMemberData(completion:{[weak self] (user) in
            if user.count != 0{
                self?.memberData = user
            }
        })
        print(UserDefaults.standard.string(forKey: "USERID")!)
        GetMemberData.getProfile(userUID: UserDefaults.standard.string(forKey: "USERID")!) {[weak self] (user) in
            self?.userInfo = user
            self?.lbName.text = self?.userInfo.name
            
            let data = try? Data(contentsOf: URL(string: (self?.userInfo.image)!)!)
            DispatchQueue.main.async {
                self?.imgAvatar.image = UIImage(data: data!)
            }
            
        }
        GetStatusData.getStatusData {[weak self] (status) in
            print("test")
            self?.statusData = status
            DispatchQueue.main.async {
                self?.newFeedCollection.reloadData()
                self?.loadingIcon.stopAnimating()
                self?.loadingIcon.isHidden = true
            }
        }
    }
    func reloadNewFeedData(_ sender:Any){
        loadingIcon.isHidden = false
        loadingIcon.startAnimating()
        //get data
        GetMemberData.getMemberData(completion:{[weak self] (user) in
            if user.count != 0{
                self?.memberData = user
            }
        })
        print(UserDefaults.standard.string(forKey: "USERID")!)
        GetMemberData.getProfile(userUID: UserDefaults.standard.string(forKey: "USERID")!) {[weak self] (user) in
            self?.userInfo = user
            self?.lbName.text = self?.userInfo.name
            
            let data = try? Data(contentsOf: URL(string: (self?.userInfo.image)!)!)
            DispatchQueue.main.async {
                self?.imgAvatar.image = UIImage(data: data!)
            }
            
        }
        GetStatusData.getStatusData {[weak self] (status) in
            print("test")
            self?.statusData = status
            DispatchQueue.main.async {
                self?.newFeedCollection.reloadData()
                self?.loadingIcon.stopAnimating()
                self?.loadingIcon.isHidden = true
                self?.refresh.endRefreshing()
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
        
        self.viewContainNewFeed.isUserInteractionEnabled = true
        self.viewButtonAdd.isUserInteractionEnabled = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        //Dispose of any resources that can be recreated.
    }
    
    
    
// CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statusData.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newFeedViewCell", for: indexPath) as! NewFeedViewCell
        
        
        if let image = cacheImage.object(forKey: statusData[indexPath.row].image as NSString){
            cell.imgmain.image = image
        }else{
            print("Not")
            cell.imgmain.image = nil
            let url = URL(string: statusData[indexPath.row].image)
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print((error?.localizedDescription)!)
                }else if data != nil{
                    let imageCache = UIImage(data: data!)
                    self.cacheImage.setObject(imageCache!, forKey: self.statusData[indexPath.row].image as NSString)
                    DispatchQueue.main.async {
                        UIView.transition(with: cell.imgmain, duration: 0.3, options: .transitionCrossDissolve, animations: { 
                            cell.imgmain.image = imageCache
                            cell.indicator.stopAnimating()
                            cell.indicator.isHidden = true
                        }, completion: nil)
                    }
                }
            }).resume()
        }
        //Member Info
        if let member = foundMember(statusData[indexPath.item].idMember) {
            cell.lbName.text = member.name
            
            //Get index of member in memberData
            if let index = memberData.index(where: { (item:Member) -> Bool in
                item.idMember == member.idMember
            }){
                cell.btnMemberDetail.tag = index
            }
            
            cell.btnMemberDetail.addTarget(self, action: #selector(clickOnMoreDetailMember(_:)), for: .touchUpInside)
            if let image = cacheImage.object(forKey: member.idMember! as NSString){
                cell.imgAvatar.image = image
            }else{
                cell.imgAvatar.image = nil
                let url = URL(string: member.image)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if error != nil {
                        print((error?.localizedDescription)!)
                    }else if data != nil{
                        let imageCache = UIImage(data: data!)
                        let imageCorner = imageCache?.createRadius(newsize: cell.imgAvatar.bounds.size, radius: 20.0, byRoundingCorner: [.topRight,.topLeft,.bottomLeft,.bottomRight])
                        self.cacheImage.setObject(imageCorner!, forKey: member.idMember! as NSString)
                        DispatchQueue.main.async {
                            UIView.transition(with: cell.imgAvatar, duration: 0.3, options: .transitionCrossDissolve, animations: {
                                cell.imgAvatar.image = imageCorner
                            }, completion: nil)
                        }
                    }
                }).resume()
            }
            
        }
        
        cell.lbTime.text = statusData[indexPath.item].time
        cell.Status.text = statusData[indexPath.item].status
        
        
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
    
    //End Config CollectionView
    
    
    func foundMember(_ idMember:String) -> Member?{
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
    
    
    
    
    
//    func resizeImage(with image: UIImage) -> UIImage {
//        let newSize = CGSize(width: self.view.frame.width, height: (self.view.frame.width*image.size.height)/image.size.width)
//        UIGraphicsBeginImageContext(newSize)
//        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
//        let newImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage!
//    }
}


extension UIImage{
    func createRadius(newsize:CGSize,radius:CGFloat,byRoundingCorner:UIRectCorner?) -> UIImage?{
        UIGraphicsBeginImageContextWithOptions(newsize, false, 0.0)
        let imgRect = CGRect(x: 0, y: 0, width: newsize.width, height: newsize.height)
        if let roundingCorner = byRoundingCorner{
            UIBezierPath(roundedRect: imgRect, byRoundingCorners: roundingCorner, cornerRadii: CGSize(width: radius, height: radius)).addClip()
        }else{
            UIBezierPath(roundedRect: imgRect, cornerRadius: radius).addClip()
        }
        self.draw(in: imgRect)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return result
    }
}
