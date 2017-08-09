//
//  ListFriendController.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/4/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import UIKit

class ListFriendController: UIViewController,UITableViewDataSource,UITableViewDelegate{

    @IBOutlet var btnBack: UIButton!
    @IBOutlet var tbvListFriend: UITableView!
    
    var friendData:[Member] = GetMemberData.getMemberData()
    var selectIndex:Int = -1
    var Expand:[Bool] = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //prepare for tableview
        tbvListFriend.delegate = self
        tbvListFriend.dataSource = self
        let nib:UINib = UINib(nibName: "ListFriendTableViewCell", bundle: nil)
        tbvListFriend.register(nib, forCellReuseIdentifier: "listFriendTableViewCell")
        for _ in 0..<friendData.count{
            Expand.append(false)
        }
        print(Expand.count)
    }
    override func viewWillAppear(_ animated: Bool) {
        btnBack.setImage(UIImage(named: "icon_backspace")?.tint(with: UIColor.white), for: .normal)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("cell for row")
        let cell = tableView.dequeueReusableCell(withIdentifier: "listFriendTableViewCell", for: indexPath) as! ListFriendTableViewCell
        let member = friendData[indexPath.row]
        
        cell.imgAvatar.image = UIImage(named: member.image)
        cell.lbName.text = member.name
        cell.lbAddress.text = member.address
        cell.lbPhone.text = member.phoneNumber
        cell.lbEmail.text = member.email
        cell.selectionStyle = .none
        if Expand[indexPath.row]{
            cell.viewExpand.isHidden = false
        }else{
            cell.viewExpand.isHidden = true
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("Height")
        if selectIndex != -1{
            if selectIndex == indexPath.row && Expand[indexPath.row]{
                return 120.0
            }else{
                return 60.0
            }
        }else{
            return 60.0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectIndex = indexPath.row
        for i in 0..<Expand.count{
            if i == selectIndex{
                Expand[selectIndex] = !Expand[selectIndex]
            }else{
                Expand[i] = false
            }
        }
        for i in 0..<friendData.count{
            let indexPath2:IndexPath = IndexPath(row: i, section: 0)
            if let cell = tableView.cellForRow(at: indexPath2) as? ListFriendTableViewCell{
                UIView.transition(with: cell.viewExpand, duration: 0.4, options: .transitionFlipFromTop, animations: {
                    cell.viewExpand.isHidden = !self.Expand[i]
                }, completion: nil)
            }
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    @IBAction func clickOnButtonBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
