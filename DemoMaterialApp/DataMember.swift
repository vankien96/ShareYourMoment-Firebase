//
//  DataMember.swift
//  DemoMaterialApp
//
//  Created by TPPFIT iCloud on 8/3/17.
//  Copyright © 2017 TPPFIT iCloud. All rights reserved.
//

import Foundation
import Firebase

struct Member{
    var idMember:String!
    var name:String!
    var image:String!
    var phoneNumber:String!
    var email:String!
    var address:String!
    var about:String!
}
class GetMemberData{
    class func getMemberData(completion: @escaping (([Member]) -> Void)){
        var memberData:[Member] = [Member]()
        var ref:FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        ref.child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            if let value = snapshot.value as? [String:Any]{
                print(value)
                for item in value{
                    var user:Member = Member()
                    user.idMember = item.key
                    if let dicInfo = item.value as? [String:String]{
                        user.about = dicInfo["About"]
                        user.address = dicInfo["Address"]
                        user.email = dicInfo["Email"]
                        user.image = dicInfo["Image"]
                        user.phoneNumber = dicInfo["Phone"]
                        user.name = dicInfo["Name"]
                        memberData.append(user)
                    }
                }
                completion(memberData)
            }else{
                print("Error")
            }
        })
    }
    class func getProfile(userUID:String ,completion: @escaping ((Member) -> Void)){
        print(userUID)
        var ref:FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        var userInfo = Member()
        ref.child("users").child(userUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value:[String:String] = snapshot.value as? [String:String]{
                userInfo.idMember = userUID
                userInfo.name = value["Name"]
                userInfo.phoneNumber = value["Phone"]
                userInfo.address = value["Address"]
                userInfo.email = value["Email"]
                userInfo.image = value["Image"]
                userInfo.about = value["About"]
                completion(userInfo)
            }
        })
    }
}
