//
//  DataNewFeed.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/3/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import Foundation
import UIKit
struct AStatus{
    var idMember:String!
    var time:String!
    var status:String!
    var image:UIImage!
}

class GetStatusData{
    class func getStatusData() -> [AStatus]{
        var statusData = [AStatus]()
        for i in 0...10{
            var aStatus = AStatus(idMember: "001", time: "Today, 1:45 AM", status: "You tell me that you love me but say I'm just a friend", image: UIImage(named: "imgFeed"))
            statusData.append(aStatus)
            aStatus = AStatus(idMember: "002", time: "Today, 2:30 AM", status: "2 AM I called but you didn't answer", image: UIImage(named: "imgSample1"))
            statusData.append(aStatus)
            
            aStatus = AStatus(idMember: "003", time: "02/08/2017, 7:00 AM", status: "She's so beautiful , And I tell her every day", image: UIImage(named: "imgSample2"))
            statusData.append(aStatus)
            
            aStatus = AStatus(idMember: "004", time: "01/08/2017, 12:00 PM", status: "I was home and I learned to play the chords true and strong. Now I have found where I belong", image: UIImage(named: "imgSample3"))
            statusData.append(aStatus)
            
            aStatus = AStatus(idMember: "002", time: "01/08/2017, 4:00 PM", status: "Cause I just wanna make your wife babe", image: UIImage(named: "imgSample2"))
            statusData.append(aStatus)
        }
        return statusData
    }
}
