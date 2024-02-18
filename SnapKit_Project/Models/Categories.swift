//
//  Categories.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 01.12.2023.
//

import Foundation
import SwiftyJSON

class Categories {
    
    /*
     "categories": [
                 {
                     "id": 1,
                     "name": "ÖZINŞE–де танымал",
                     "fileId": null,
                     "link": "http://api.ozinshe.com/core/public/V1/show/null",
                     "movieCount": null
                 },
     */
    public var id: Int = 0
    public var name: String = ""
    public var fileId: Int = 0
    public var link: String = ""
    public var movieCount: Int = 0
    
    init(json: JSON) {
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["name"].string {
            self.name = temp
        }
        if let temp = json["fileId"].int {
            self.fileId = temp
        }
        if let temp = json["link"].string {
            self.link = temp
        }
        if let temp = json["movieCount"].int {
            self.movieCount = temp
        }
    }
}

