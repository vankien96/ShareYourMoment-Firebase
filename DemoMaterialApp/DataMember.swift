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
    class func getMemberData() -> [Member]{
        var memberData:[Member] = [Member]()
        var member = Member(idMember: "001", name: "Trương Văn Kiên", image: "man2", phoneNumber: "0946876983", email: "vankien1004@gmail.com", address: "66 Vo Van Tan, Da Nang",about: "")
        memberData.append(member)
        
        member = Member(idMember: "002", name: "Jordan Robinson", image: "man3", phoneNumber: "0969645289", email: "khongbiettengi@gmail.com", address: "LA, American",about: "")
        memberData.append(member)
        
        member = Member(idMember: "003", name: "Jose Ewards", image: "man4", phoneNumber: "01214505045", email: "joseandjuliet@gmail.com", address: "Bejing, China",about: "")
        memberData.append(member)
        
        member = Member(idMember: "004", name: "Helen Berry", image: "man5", phoneNumber: "63526983", email: "Heliox20@gmail.com", address: "Xvanika, Germany",about: "")
        memberData.append(member)
        
        
        return memberData
    }
    class func getProfile(userUID:String ,completion: @escaping ((Member) -> Void)){
        print(userUID)
        var ref:FIRDatabaseReference!
        ref = FIRDatabase.database().reference()
        var userInfo = Member()
        ref.child("users").child(userUID).observeSingleEvent(of: .value, with: { (snapshot) in
            if let value:[String:String] = snapshot.value as! [String:String]{
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
