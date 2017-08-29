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
    var image:String!
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
                        status.image = infoDic["Image"]
                        status.status = infoDic["Content"]
                        status.time = infoDic["Time"]
                        status.idMember = infoDic["UserID"]
                    }
                    print("finished")
                    statusData.append(status)
                }
                statusData.sort(by: { (a, b) -> Bool in
                    return a.time > b.time
                })
                completion(statusData)
            }
        })
    }
}
