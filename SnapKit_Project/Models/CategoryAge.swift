//
//  CategoryAge.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 23.02.2024.
//

import Foundation
import SwiftyJSON

struct CategoryAge {
    var id = 0
    var name = ""
    var link = ""
    
    init(json: JSON) {
        if let temp = json["id"].int {
            id = temp
        }
        if let temp = json["name"].string {
            name = temp
        }
        if let temp = json["link"].string {
            link = temp
        }
    }

}
