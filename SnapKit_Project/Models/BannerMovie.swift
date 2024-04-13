//
//  BannerMovie.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 23.02.2024.
//

import Foundation
import SwiftyJSON

struct BannerMovie {
    var id = 0
    var link = ""
    var movie = Movie()
    
    init() {
        
    }
    
    init(json: JSON) {
        if let temp = json["id"].int {
            id = temp
        }
        if let temp = json["link"].string {
            link = temp
        }
        if json["movie"].exists() {
            movie = Movie(json: json["movie"])
        }
    }
}
