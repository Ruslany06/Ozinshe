//
//  Profile.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 21.03.2024.
//

import Foundation
import SwiftyJSON

struct Profile {
    
    var id = 0
    var user_email = ""
    var name = ""
    var phoneNumber = ""
    var birthDate = ""
    var language = ""
    
    init() {
        
    }

    init(json: JSON) {
        if let temp = json["id"].int {
            id = temp
        }
        
        if json["user"].exists() {
            if let temp = json["user"]["email"].string {
                user_email = temp
            }
        }
        if let temp = json["name"].string {
            name = temp
        }
        if let temp = json["phoneNumber"].string {
            phoneNumber = temp
        }
        if let temp = json["birthDate"].string {
            birthDate = temp
        }
        if let temp = json["language"].string {
            language = temp
        }
    }

    
}
