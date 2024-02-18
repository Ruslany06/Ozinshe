//
//  Screenshot.swift
//  SnapKit_Project
//
//  Created by Ruslan Yelguldinov on 01.12.2023.
//

import Foundation
import SwiftyJSON

/*"screenshots": [
            {
                "id": 156,
                "link": "http://api.ozinshe.com/core/public/V1/show/636",
                "fileId": 636,
                "movieId": 123
            }
        ],
*/
class Screenshots {
    public var id: Int = 0
    public var link: String = ""
    public var fileId: Int = 0
    public var movieId: Int = 0
    
    init(json: JSON) {
        if let temp = json["id"].int {
            self.id = temp
        }
        if let temp = json["link"].string {
            self.link = temp
        }
        if let temp = json["fileId"].int {
            self.fileId = temp
        }
        if let temp = json["movieId"].int {
            self.movieId = temp
        }
    }
}
