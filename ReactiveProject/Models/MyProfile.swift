//
//  MyProfile.swift
//  ReactiveProject
//
//  Created by Aleksandr Vorobev on 25.04.2020.
//  Copyright © 2020 Aleksandr Vorobev. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
class MyProfile: Object {
    
    static let profileID = "id#0"
    
    dynamic var id = MyProfile.profileID
    dynamic var balance: Float = 5000.0
    dynamic var lastFullBalance: Float = 5000.0
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
