//
//  DataNewFeed.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/3/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import Foundation
import UIKit
import Firebase
struct AStatus{
    var idMember:String!
    var time:String!
    var status:String!
    var image:UIImage!
}

class GetStatusData{
    class func getStatusData(completion: @escaping (([AStatus])->Void)){
        var statusData = [AStatus]()
        let ref = FIRDatabase.database().reference().child("status")
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String:Any]{
                for item in value{
                    var status = AStatus()
                    if let infoDic = item.value as? [String:String]{
                        let data = try? Data(contentsOf: URL(string: infoDic["Image"]!)!)
                        let image = UIImage(data: data!)
                        status.image = image
                        status.status = infoDic["Content"]
                        status.time = infoDic["Time"]
                        status.idMember = infoDic["UserID"]
                    }
                    statusData.append(status)
                }
                completion(statusData)
            }
        })
        
    }
}
